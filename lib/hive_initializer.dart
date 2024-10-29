import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:necta_test4/models/error_model.dart';
import 'package:necta_test4/models/qt_model.dart';
import 'package:necta_test4/models/school_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveInitializer {
  static Future<void> initHive() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      // Register adapters for school_model.dart (typeId: 0-7)
      Hive.registerAdapter(SchoolAdapter());
      Hive.registerAdapter(SchoolInfoAdapter());
      Hive.registerAdapter(StudentStatsAdapter());
      Hive.registerAdapter(DivisionCountAdapter());
      Hive.registerAdapter(DivisionsAdapter());
      Hive.registerAdapter(CentreAdapter());
      Hive.registerAdapter(SubjectAdapter());
      Hive.registerAdapter(StudentResultAdapter());

      // Register adapters for qt_model.dart (typeId: 8-13)
      Hive.registerAdapter(SchoolQtAdapter());
      Hive.registerAdapter(SchoolInfoQtAdapter());
      Hive.registerAdapter(DivisionCountQtAdapter());
      Hive.registerAdapter(DivisionsQtAdapter());
      Hive.registerAdapter(SubjectQtAdapter());
      Hive.registerAdapter(StudentResultQtAdapter());

      // Register adapter for error_model.dart (typeId: 14)
      Hive.registerAdapter(ErrorSchoolAdapter());

      // // Open boxes
      // await Hive.openLazyBox<School>(DETAILED_RESULTS_BOX);
      // await Hive.openLazyBox<Map<String, dynamic>>(STATISTICS_BOX);
    } catch (e) {
      print('Error initializing Hive: $e');
      throw Exception('Failed to initialize Hive: $e');
    }
  }
}
