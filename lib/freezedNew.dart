// models/school.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'school.freezed.dart';
part 'school.g.dart';

@HiveType(typeId: 0)
@freezed
class School with _$School {
  const factory School({
    @HiveField(0) required SchoolInfo school,
    @HiveField(1) required List<StudentStats> students,
    @HiveField(2) required Divisions divisions,
    @HiveField(3) required List<Centre> centre,
    @HiveField(4) required List<StudentResult> results,
  }) = _School;

  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);
}

@HiveType(typeId: 1)
@freezed
class SchoolInfo with _$SchoolInfo {
  const factory SchoolInfo({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String url,
    @HiveField(3) required String region,
    @HiveField(4) required String passed,
    @HiveField(5) required String gpa,
    @HiveField(6) required String grade,
  }) = _SchoolInfo;

  factory SchoolInfo.fromJson(Map<String, dynamic> json) => 
      _$SchoolInfoFromJson(json);
}

@HiveType(typeId: 2)
@freezed
class StudentStats with _$StudentStats {
  const factory StudentStats({
    @HiveField(0) required String registered,
    @HiveField(1) required String absent,
    @HiveField(2) required String sat,
    @HiveField(3) required String withheld,
    @HiveField(4) required String noca,
    @HiveField(5) required String clean,
  }) = _StudentStats;

  factory StudentStats.fromJson(Map<String, dynamic> json) =>
      _$StudentStatsFromJson(json);
}

@HiveType(typeId: 3)
@freezed
class DivisionCount with _$DivisionCount {
  const factory DivisionCount({
    @JsonKey(name: 'I') @HiveField(0) @Default(0) int divI,
    @JsonKey(name: 'II') @HiveField(1) @Default(0) int divII,
    @JsonKey(name: 'III') @HiveField(2) @Default(0) int divIII,
    @JsonKey(name: 'IV') @HiveField(3) @Default(0) int divIV,
    @JsonKey(name: '0') @HiveField(4) @Default(0) int div0,
  }) = _DivisionCount;

  factory DivisionCount.fromJson(Map<String, dynamic> json) {
    return _$DivisionCountFromJson({
      'I': int.tryParse(json['I']?.toString() ?? '0') ?? 0,
      'II': int.tryParse(json['II']?.toString() ?? '0') ?? 0,
      'III': int.tryParse(json['III']?.toString() ?? '0') ?? 0,
      'IV': int.tryParse(json['IV']?.toString() ?? '0') ?? 0,
      '0': int.tryParse(json['0']?.toString() ?? '0') ?? 0,
    });
  }
}

@HiveType(typeId: 4)
@freezed
class Divisions with _$Divisions {
  const factory Divisions({
    @HiveField(0) required DivisionCount female,
    @HiveField(1) required DivisionCount male,
    @HiveField(2) required DivisionCount total,
  }) = _Divisions;

  factory Divisions.fromJson(Map<String, dynamic> json) =>
      _$DivisionsFromJson(json);
}

@HiveType(typeId: 5)
@freezed
class Centre with _$Centre {
  const factory Centre({
    @HiveField(0) required String code,
    @HiveField(1) required String name,
    @HiveField(2) required String registered,
    @HiveField(3) required String sat,
    @HiveField(4) required String noca,
    @HiveField(5) required String withheld,
    @HiveField(6) required String clean,
    @HiveField(7) required String pass,
    @HiveField(8) required String gpa,
    @HiveField(9) required String grade,
  }) = _Centre;

  factory Centre.fromJson(Map<String, dynamic> json) => _$CentreFromJson(json);
}

@HiveType(typeId: 6)
@freezed
class Subject with _$Subject {
  const factory Subject({
    @HiveField(0) required String code,
    @HiveField(1) required String grade,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);
}

@HiveType(typeId: 7)
@freezed
class StudentResult with _$StudentResult {
  const factory StudentResult({
    @HiveField(0) required String studentId,
    @HiveField(1) required String sex,
    @HiveField(2) required String aggregate,
    @HiveField(3) required String division,
    @HiveField(4) required List<Subject> subjects,
  }) = _StudentResult;

  factory StudentResult.fromJson(Map<String, dynamic> json) =>
      _$StudentResultFromJson(json);
}

// Initialize Hive and register adapters
Future<void> initHive() async {
  await Hive.initFlutter();
  
  // Register the generated adapters
  Hive.registerAdapter(SchoolAdapter());
  Hive.registerAdapter(SchoolInfoAdapter());
  Hive.registerAdapter(StudentStatsAdapter());
  Hive.registerAdapter(DivisionCountAdapter());
  Hive.registerAdapter(DivisionsAdapter());
  Hive.registerAdapter(CentreAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(StudentResultAdapter());
}

// Example repository
class SchoolRepository {
  static const String boxName = 'schoolBox';
  
  Future<Box<School>> get _box async => 
      await Hive.openBox<School>(boxName);

  Future<void> saveSchool(School school) async {
    final box = await _box;
    await box.put('currentSchool', school);
  }

  Future<School?> getSchool() async {
    final box = await _box;
    return box.get('currentSchool');
  }

  Future<void> deleteSchool() async {
    final box = await _box;
    await box.delete('currentSchool');
  }
}

// Example Riverpod provider
@riverpod
class SchoolNotifier extends _$SchoolNotifier {
  late final _repository = SchoolRepository();

  @override
  Future<School?> build() async {
    return _repository.getSchool();
  }

  Future<void> saveSchool(School school) async {
    await _repository.saveSchool(school);
    ref.invalidateSelf();
  }

  Future<void> deleteSchool() async {
    await _repository.deleteSchool();
    ref.invalidateSelf();
  }
}

// Example usage
void example() async {
  // Create a new school
  final school = School(
    school: const SchoolInfo(
      id: '1',
      name: 'Example School',
      url: 'http://example.com',
      region: 'East',
      passed: '90%',
      gpa: '3.5',
      grade: 'A'
    ),
    students: [],
    divisions: const Divisions(
      female: DivisionCount(),
      male: DivisionCount(),
      total: DivisionCount(),
    ),
    centre: [],
    results: []
  );

  // Use copyWith
  final updatedSchool = school.copyWith(
    school: school.school.copyWith(name: 'New Name')
  );

  // Save to Hive
  final repository = SchoolRepository();
  await repository.saveSchool(updatedSchool);
}