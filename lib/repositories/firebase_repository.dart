import 'dart:isolate';
import 'package:archive/archive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:necta_test4/models/error_model.dart';
import 'package:necta_test4/models/qt_model.dart';
import 'package:necta_test4/models/school_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'dart:convert';

part 'firebase_repository.g.dart';

const String DETAILED_RESULTS_BOX = 'detailed_results';
const String STATISTICS_BOX = 'statistics';
const String QT_BOX = 'qt_schools';

class ProcessTimings {
  final Duration downloadTime;
  final Duration decompressionTime;
  final Duration parsingTime;
  final Duration storageTime;
  final int processedFiles;
  final int totalBytes;

  ProcessTimings({
    required this.downloadTime,
    required this.decompressionTime,
    required this.parsingTime,
    required this.storageTime,
    required this.processedFiles,
    required this.totalBytes,
  });

  Map<String, dynamic> toJson() => {
        'downloadTime': downloadTime.inMilliseconds,
        'decompressionTime': decompressionTime.inMilliseconds,
        'parsingTime': parsingTime.inMilliseconds,
        'storageTime': storageTime.inMilliseconds,
        'processedFiles': processedFiles,
        'totalBytes': totalBytes,
        'averageTimePerFile': processedFiles > 0 ? (downloadTime + decompressionTime + parsingTime + storageTime).inMilliseconds / processedFiles : 0,
        'processingSpeed': totalBytes > 0 ? (totalBytes / (downloadTime + decompressionTime + parsingTime + storageTime).inSeconds).round() : 0, // bytes per second
      };
}

class FirebaseRepository {
  final FirebaseStorage _storage;
  final LazyBox<School> _detailedResultsBox;
  final LazyBox<SchoolQt> _qtSchoolsBox;
  final LazyBox<Map<String, dynamic>> _statisticsBox;

  FirebaseRepository(this._storage, this._detailedResultsBox, this._statisticsBox, this._qtSchoolsBox);

  static Future<void> initHive() async {
    await Hive.openLazyBox<School>(DETAILED_RESULTS_BOX);
    await Hive.openLazyBox<Map<String, dynamic>>(STATISTICS_BOX);
    await Hive.openLazyBox<Map<String, dynamic>>(QT_BOX);
  }

  Future<Map<String, dynamic>> downloadAndProcessFiles(String path) async {
    final Stopwatch totalTimer = Stopwatch()..start();
    final Stopwatch downloadTimer = Stopwatch();
    final Stopwatch storageTimer = Stopwatch();
    int totalBytes = 0;

    try {
      print('reached here');
      final ListResult result = await _storage.refFromURL(path).listAll();
      print(result);
      List<Map<String, dynamic>> processedData = [];
      List<String> errors = [];

      for (var fileRef in result.items) {
        print('reached here');
        if (fileRef.name.endsWith('.zip')) {
          // Measure download time
          downloadTimer.start();
          final tempFile = File('${Directory.systemTemp.path}/${fileRef.name}');
          await fileRef.writeToFile(tempFile);
          downloadTimer.stop();

          totalBytes += await tempFile.length();

          // Process in isolate and track timing
          final data = await _processZipFileInIsolate(tempFile.path);

          if (data['error'] != null) {
            errors.add('${fileRef.name}: ${data['error']}');
          } else {
            // Measure storage time
            storageTimer.start();
            await _storeProcessedData(data['data']);
            storageTimer.stop();

            processedData.add({'filename': fileRef.name, 'summary': data['summary'], 'timings': data['timings']});
          }

          await tempFile.delete();
        }
      }

      totalTimer.stop();

      final timings = ProcessTimings(
        downloadTime: downloadTimer.elapsed,
        decompressionTime: Duration(milliseconds: processedData.fold(0, (sum, item) => sum + (item['timings']['decompressionTime'] as int))),
        parsingTime: Duration(milliseconds: processedData.fold(0, (sum, item) => sum + (item['timings']['parsingTime'] as int))),
        storageTime: storageTimer.elapsed,
        processedFiles: processedData.length,
        totalBytes: totalBytes,
      );

      return {
        'processed': processedData,
        'errors': errors,
        'timings': timings.toJson(),
        'totalTime': totalTimer.elapsed.inMilliseconds,
      };
    } catch (e) {
      throw Exception('Failed to process files: $e');
    }
  }

  Future<void> _storeProcessedData(Map<String, dynamic> data) async {
    if (data['schools'] != null) {
      for (School school in data['schools']) {
        await _detailedResultsBox.put(school.school.id, school);
      }
    }

    if (data['qt'] != null) {
      for (SchoolQt school in data['qt']) {
        await _qtSchoolsBox.put(school.school.id, school);
      }
    }

    if (data['statistics'] != null) {
      for (Map<String, dynamic> stat in data['statistics']) {
        String schoolId = stat['school']['id'];
        await _statisticsBox.put(schoolId, stat);
      }
    }
  }

  Future<Map<String, dynamic>> _processZipFileInIsolate(String filePath) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(_processFileIsolate, {
      'sendPort': receivePort.sendPort,
      'filePath': filePath,
    });

    return await receivePort.first;
  }

  static Future<void> _processFileIsolate(Map<String, dynamic> message) async {
    final SendPort sendPort = message['sendPort'];
    final String filePath = message['filePath'];

    final Stopwatch decompressionTimer = Stopwatch();
    final Stopwatch parsingTimer = Stopwatch();

    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      decompressionTimer.start();
      final archive = ZipDecoder().decodeBytes(bytes);
      decompressionTimer.stop();

      List<School> schools = [];
      List<Map<String, dynamic>> statistics = [];
      List<String> errors = [];

      for (final file in archive) {
        if (file.isFile && file.name.endsWith('.xz')) {
          try {
            decompressionTimer.start();
            final decompressed = XZDecoder().decodeBytes(file.content);
            final jsonString = utf8.decode(decompressed);
            decompressionTimer.stop();

            parsingTimer.start();
            final jsonData = json.decode(jsonString);

            if (_isDetailedSchema(jsonData)) {
              schools.add(School.fromJson(jsonData));
            } else if (_isStatisticsSchema(jsonData)) {
              statistics.add(jsonData);
            } else {
              errors.add('Invalid schema: ${file.name}');
            }
            parsingTimer.stop();
          } catch (e) {
            errors.add('Processing error in ${file.name}: $e');
          }
        }
      }

      sendPort.send({
        'data': {
          'schools': schools,
          'statistics': statistics,
        },
        'errors': errors,
        'summary': {
          'schoolsCount': schools.length,
          'statisticsCount': statistics.length,
          'errorsCount': errors.length,
          'schoolsList': schools.map((s) => s.school.name).toList(),
          'statisticsSchoolsList': statistics.map((s) => s['school']['name']).toList(),
        },
        'timings': {
          'decompressionTime': decompressionTimer.elapsed.inMilliseconds,
          'parsingTime': parsingTimer.elapsed.inMilliseconds,
        }
      });
    } catch (e) {
      sendPort.send({'error': e.toString()});
    }
  }

  static bool _isDetailedSchema(Map<String, dynamic> json) {
    return json.containsKey('results') && json.containsKey('divisions') && json.containsKey('centre');
  }

  static bool _isStatisticsSchema(Map<String, dynamic> json) {
    return json.containsKey('school') && json.containsKey('subjects') && json['school'].containsKey('nationalwise');
  }
}

@riverpod
class SchoolsDownloader extends _$SchoolsDownloader {
  @override
  Future<Map<String, dynamic>> build() async {
    return {};
  }

  Future<void> downloadAndProcessSchools(String path) async {
    state = const AsyncValue.loading();

    try {
      print('OPENING LAZY BOXES');
      final detailedBox = await Hive.openLazyBox<School>(DETAILED_RESULTS_BOX);
      final qtBox = await Hive.openLazyBox<SchoolQt>(QT_BOX);
      final statsBox = await Hive.openLazyBox<Map<String, dynamic>>(STATISTICS_BOX);

      final repository = FirebaseRepository(FirebaseStorage.instance, detailedBox, statsBox, qtBox);
      print('FINISHED OPENING LAZY BOXES');

      print('STARTED DOWNLOADING');
      print('STARTED DOWNLOADING');

      final results = await repository.downloadAndProcessFiles(path);

      print('FINISHED DOWNLOADING');
      print('FINISHED DOWNLOADING');

      state = AsyncValue.data({
        'results': results,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Print timing information
      print('\nProcess Timings:');
      print('Download Time: ${results['timings']['downloadTime']}ms');
      print('Decompression Time: ${results['timings']['decompressionTime']}ms');
      print('Parsing Time: ${results['timings']['parsingTime']}ms');
      print('Storage Time: ${results['timings']['storageTime']}ms');
      print('Total Time: ${results['totalTime']}ms');
      print('Files Processed: ${results['timings']['processedFiles']}');
      print('Total Bytes: ${results['timings']['totalBytes']} bytes');
      print('Average Time per File: ${results['timings']['averageTimePerFile']}ms');
      print('Processing Speed: ${results['timings']['processingSpeed']} bytes/second\n');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
