import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:necta_test4/firebase_options.dart';
import 'package:necta_test4/hive_initializer.dart';
import 'package:necta_test4/repositories/firebase_repository.dart';
import 'package:necta_test4/stat.dart';
import 'package:necta_test4/test.dart';
import 'package:necta_test4/ui.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WakelockPlus.enable();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await HiveInitializer.initHive();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 32, 114, 7)),
          useMaterial3: true,
        ),
        home: SchoolStatsView()

        //  DataViewer(
        //   zipUrl: 'gs://necta-test1-81f48.appspot.com/csee/2023/2023.zip',
        // ),
        );
  }
}
