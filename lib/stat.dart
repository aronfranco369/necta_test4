import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:necta_test4/details.dart';
import 'package:necta_test4/models/school_model.dart';
import 'package:necta_test4/repositories/firebase_repository.dart';
import 'package:necta_test4/stat2.dart';

const String STATISTICS_BOX = 'statistics';

class SchoolStatsView extends ConsumerStatefulWidget {
  const SchoolStatsView({Key? key}) : super(key: key);

  @override
  ConsumerState<SchoolStatsView> createState() => _SchoolStatsViewState();
}

class _SchoolStatsViewState extends ConsumerState<SchoolStatsView> {
  late LazyBox<dynamic> _statisticsBox;
  late LazyBox<School> _detailedResultsBox;
  List<Map<String, dynamic>> _schools = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      _statisticsBox = await Hive.openLazyBox(STATISTICS_BOX);

      await _loadSchools();
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize database: $e';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic>? _convertDynamicMap(dynamic data) {
    if (data == null) return null;

    try {
      if (data is Map) {
        return Map<String, dynamic>.from(data.map(
          (key, value) {
            if (value is Map) {
              return MapEntry(key.toString(), _convertDynamicMap(value));
            } else {
              return MapEntry(key.toString(), value);
            }
          },
        ));
      }
    } catch (e) {
      print('Error converting map: $e');
    }
    return null;
  }

  Future<void> _fetchSchools() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(schoolsDownloaderProvider.notifier).downloadAndProcessSchools('gs://necta-test1-81f48.appspot.com/csee/2023/');
    } catch (e) {
      print('Error loading schools: $e');
      if (mounted) {
        setState(() {
          _error = 'Error loading schools: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadSchools() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final List<Map<String, dynamic>> schools = [];

      for (final key in _statisticsBox.keys) {
        final dynamic rawData = await _statisticsBox.get(key);
        final convertedData = _convertDynamicMap(rawData);

        if (convertedData != null) {
          schools.add(convertedData);
        }
      }

      print('Successfully loaded ${schools.length} schools');

      if (mounted) {
        setState(() {
          _schools = schools;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading schools: $e');
      if (mounted) {
        setState(() {
          _error = 'Error loading schools: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Statistics'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: TextStyle(color: Colors.red)),
                      ElevatedButton(
                        onPressed: _loadSchools,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _schools.isEmpty
                  ? const Center(child: Text('No schools found'))
                  : RefreshIndicator(
                      onRefresh: _loadSchools,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _schools.length,
                        itemBuilder: (context, index) {
                          final school = _schools[index]['school'] as Map<String, dynamic>? ?? {};
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SchoolDetailsScreen(
                                      schoolId: school['id']?.toString() ?? 'N/A',
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                school['name']?.toString() ?? 'Unknown School',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${school['id']?.toString() ?? 'N/A'}'),
                                  Text('Region: ${school['region']?.toString() ?? 'N/A'}'),
                                  Text('District: ${school['district']?.toString() ?? 'N/A'}'),
                                  if (school['nationalwise'] != null) Text('National Rank: ${school['nationalwise']}'),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print('reached here');
          await ref.read(schoolsDownloaderProvider.notifier).downloadAndProcessSchools('gs://necta-test1-81f48.appspot.com/csee/2023/');
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
