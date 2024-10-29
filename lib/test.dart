import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:necta_test4/repositories/firebase_repository.dart';

class SchoolListScreen extends ConsumerWidget {
  SchoolListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final downloaderProvider = Provider((ref) => ref.watch(schoolsDownloaderProvider));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schools'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              print('reached here');
              await ref.read(schoolsDownloaderProvider.notifier).downloadAndProcessSchools('gs://necta-test1-81f48.appspot.com/csee/2023/');
            },
          ),
        ],
      ),
    );
  }
}
