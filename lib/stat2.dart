import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:necta_test4/models/school_model.dart';

const String DETAILED_RESULTS_BOX = 'detailed_results';

class DetailedSchoolView extends StatefulWidget {
  final String schoolId;

  const DetailedSchoolView({Key? key, required this.schoolId}) : super(key: key);

  @override
  _DetailedSchoolViewState createState() => _DetailedSchoolViewState();
}

class _DetailedSchoolViewState extends State<DetailedSchoolView> {
  late LazyBox<School> _detailedResultsBox;
  School? _school;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      _detailedResultsBox = await Hive.openLazyBox<School>(DETAILED_RESULTS_BOX);
      await _loadSchoolDetails();
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize database: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSchoolDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _school = await _detailedResultsBox.get(widget.schoolId);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading school details: $e');
      if (mounted) {
        setState(() {
          _error = 'Error loading school details: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed School Information'),
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
                        onPressed: _loadSchoolDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _school == null
                  ? const Center(child: Text('No school data found'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _school!.school.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Display detailed school information here
                          Text('School ID: ${_school!.school.id}'),
                          Text('Region: ${_school!.school.region}'),
                          Text('District: ${_school!.school.passed}'),
                          // Add more detailed information as needed
                        ],
                      ),
                    ),
    );
  }
}
