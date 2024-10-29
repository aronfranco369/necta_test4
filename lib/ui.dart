import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:necta_test4/models/school_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:necta_test4/models/school_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Cache provider to store loaded schools in memory
final schoolsCacheProvider = StateProvider<List<School>?>((ref) => null);

class LoadingMetrics {
  final int totalSchools;
  final Duration loadTime;
  final double schoolsPerSecond;

  LoadingMetrics({
    required this.totalSchools,
    required this.loadTime,
    required this.schoolsPerSecond,
  });
}

class SchoolsNotifier extends StateNotifier<AsyncValue<(List<School>, LoadingMetrics?)>> {
  SchoolsNotifier(this.ref) : super(const AsyncValue.data(([], null))) {
    loadSchools();
  }

  final Ref ref;
  static const int BATCH_SIZE = 500; // Increased batch size for better performance

  Future<void> loadSchools() async {
    state = const AsyncValue.loading();
    final stopwatch = Stopwatch()..start();

    try {
      // Check cache first
      final cachedSchools = ref.read(schoolsCacheProvider);
      if (cachedSchools != null && cachedSchools.isNotEmpty) {
        print('Loading from cache: ${cachedSchools.length} schools');
        final metrics = LoadingMetrics(
          totalSchools: cachedSchools.length,
          loadTime: stopwatch.elapsed,
          schoolsPerSecond: cachedSchools.length / (stopwatch.elapsed.inMicroseconds / 1000000),
        );
        state = AsyncValue.data((cachedSchools, metrics));
        return;
      }

      final box = await Hive.openLazyBox<School>(DETAILED_RESULTS_BOX);
      print('Starting to load ${box.length} schools using batched loading...');

      final keys = box.keys.toList();
      final List<School> schools = [];
      final List<Future<void>> batchFutures = [];

      // Process in batches
      for (var i = 0; i < keys.length; i += BATCH_SIZE) {
        final endIndex = (i + BATCH_SIZE < keys.length) ? i + BATCH_SIZE : keys.length;
        final batchKeys = keys.sublist(i, endIndex);

        // Create a future for this batch
        final batchFuture = () async {
          final batchSchools = await Future.wait(
            batchKeys.map((key) => box.get(key)),
          );
          schools.addAll(batchSchools.whereType<School>());

          // Update progress
          final currentTime = stopwatch.elapsed;
          final currentRate = schools.length / (currentTime.inMicroseconds / 1000000);
          print('''
Batch Progress:
- Loaded: ${schools.length}/${box.length} schools
- Time: ${currentTime.inSeconds}.${currentTime.inMilliseconds % 1000}s
- Rate: ${currentRate.toStringAsFixed(2)} schools/second
''');

          // Update state with current progress
          final metrics = LoadingMetrics(
            totalSchools: schools.length,
            loadTime: currentTime,
            schoolsPerSecond: currentRate,
          );
          state = AsyncValue.data((List.from(schools), metrics));
        }();

        batchFutures.add(batchFuture);
      }

      // Wait for all batches to complete
      await Future.wait(batchFutures);

      // Sort schools by name for better UX
      schools.sort((a, b) => a.school.name.compareTo(b.school.name));

      // Cache the results
      ref.read(schoolsCacheProvider.notifier).state = schools;

      stopwatch.stop();
      final finalMetrics = LoadingMetrics(
        totalSchools: schools.length,
        loadTime: stopwatch.elapsed,
        schoolsPerSecond: schools.length / (stopwatch.elapsed.inMicroseconds / 1000000),
      );

      print('\nFinal Loading Metrics:');
      print('- Total Schools: ${schools.length}');
      print('- Load Time: ${finalMetrics.loadTime.inSeconds}.${finalMetrics.loadTime.inMilliseconds % 1000}s');
      print('- Schools/Second: ${finalMetrics.schoolsPerSecond.toStringAsFixed(2)}');

      state = AsyncValue.data((schools, finalMetrics));
    } catch (e, st) {
      print('Error loading schools: $e');
      stopwatch.stop();
      state = AsyncValue.error(e, st);
    }
  }

  // Method to clear cache if needed
  void clearCache() {
    ref.read(schoolsCacheProvider.notifier).state = null;
  }
}

// Updated provider definition
final schoolsProvider = StateNotifierProvider<SchoolsNotifier, AsyncValue<(List<School>, LoadingMetrics?)>>(
  (ref) => SchoolsNotifier(ref),
);

const String DETAILED_RESULTS_BOX = 'detailed_results';
const String STATISTICS_BOX = 'statistics';

class SchoolListView extends ConsumerWidget {
  const SchoolListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schools Data'),
        actions: [
          // Add cache clear button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(schoolsProvider.notifier).clearCache();
              ref.read(schoolsProvider.notifier).loadSchools();
            },
            tooltip: 'Clear Cache',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(schoolsProvider.notifier).loadSchools(),
            tooltip: 'Reload',
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final schoolsAsync = ref.watch(schoolsProvider);

          return schoolsAsync.when(
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading schools...'),
                ],
              ),
            ),
            error: (error, stack) => Center(
              child: Text('Error: ${error.toString()}'),
            ),
            data: (data) {
              final (schools, metrics) = data;
              if (schools.isEmpty) {
                return const Center(child: Text('No schools loaded'));
              }

              return Column(
                children: [
                  if (metrics != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('${metrics.totalSchools} schools'),
                          Text('${metrics.loadTime.inSeconds}.${metrics.loadTime.inMilliseconds % 1000}s'),
                          Text('${metrics.schoolsPerSecond.toStringAsFixed(2)}/s'),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: schools.length,
                      itemBuilder: (context, index) => SchoolTile(school: schools[index]),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class SchoolTile extends StatelessWidget {
  final School school;

  const SchoolTile({
    Key? key,
    required this.school,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ExpansionTile(
        title: Text(
          school.school.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'ID: ${school.school.id}',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Region', school.school.region),
                const SizedBox(height: 8),
                _buildInfoRow('District', school.school.name),
                const SizedBox(height: 8),
                _buildInfoRow('Ward', school.school.gpa),
                const SizedBox(height: 8),
                _buildInfoRow('Center Number', school.school.id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}
