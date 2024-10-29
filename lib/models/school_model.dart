import 'package:hive/hive.dart';

part 'school_model.g.dart';

@HiveType(typeId: 0)
class School extends HiveObject {
  @HiveField(0)
  final SchoolInfo school;

  @HiveField(1)
  final List<StudentStats> students;

  @HiveField(2)
  final Divisions divisions;

  @HiveField(3)
  final List<Centre> centre;

  @HiveField(4)
  final List<StudentResult> results;

  School({
    required this.school,
    required this.students,
    required this.divisions,
    required this.centre,
    required this.results,
  });

  factory School.fromJson(dynamic json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(json);
    return School(
      school: SchoolInfo.fromJson(Map<String, dynamic>.from(data['school'])),
      students: (data['students'] as List).map((x) => StudentStats.fromJson(Map<String, dynamic>.from(x))).toList(),
      divisions: Divisions.fromJson(Map<String, dynamic>.from(data['divisions'])),
      centre: (data['centre'] as List).map((x) => Centre.fromJson(Map<String, dynamic>.from(x))).toList(),
      results: (data['results'] as List).map((x) => StudentResult.fromJson(Map<String, dynamic>.from(x))).toList(),
    );
  }
}

@HiveType(typeId: 1)
class SchoolInfo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String region;

  @HiveField(4)
  final String passed;

  @HiveField(5)
  final String gpa;

  @HiveField(6)
  final String grade;

  SchoolInfo({
    required this.id,
    required this.name,
    required this.url,
    required this.region,
    required this.passed,
    required this.gpa,
    required this.grade,
  });

  factory SchoolInfo.fromJson(Map<String, dynamic> json) {
    return SchoolInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      passed: json['passed']?.toString() ?? '',
      gpa: json['gpa']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
    );
  }
}

@HiveType(typeId: 2)
class StudentStats extends HiveObject {
  @HiveField(0)
  final String registered;

  @HiveField(1)
  final String absent;

  @HiveField(2)
  final String sat;

  @HiveField(3)
  final String withheld;

  @HiveField(4)
  final String noca;

  @HiveField(5)
  final String clean;

  StudentStats({
    required this.registered,
    required this.absent,
    required this.sat,
    required this.withheld,
    required this.noca,
    required this.clean,
  });

  factory StudentStats.fromJson(Map<String, dynamic> json) {
    return StudentStats(
      registered: json['registered']?.toString() ?? '',
      absent: json['absent']?.toString() ?? '',
      sat: json['sat']?.toString() ?? '',
      withheld: json['withheld']?.toString() ?? '',
      noca: json['noca']?.toString() ?? '',
      clean: json['clean']?.toString() ?? '',
    );
  }
}

@HiveType(typeId: 3)
class DivisionCount extends HiveObject {
  @HiveField(0)
  final int divI;

  @HiveField(1)
  final int divII;

  @HiveField(2)
  final int divIII;

  @HiveField(3)
  final int divIV;

  @HiveField(4)
  final int div0;

  DivisionCount({
    required this.divI,
    required this.divII,
    required this.divIII,
    required this.divIV,
    required this.div0,
  });

  factory DivisionCount.fromJson(Map<String, dynamic> json) {
    return DivisionCount(
      divI: int.tryParse(json['I']?.toString() ?? '0') ?? 0,
      divII: int.tryParse(json['II']?.toString() ?? '0') ?? 0,
      divIII: int.tryParse(json['III']?.toString() ?? '0') ?? 0,
      divIV: int.tryParse(json['IV']?.toString() ?? '0') ?? 0,
      div0: int.tryParse(json['0']?.toString() ?? '0') ?? 0,
    );
  }
}

@HiveType(typeId: 4)
class Divisions extends HiveObject {
  @HiveField(0)
  final DivisionCount female;

  @HiveField(1)
  final DivisionCount male;

  @HiveField(2)
  final DivisionCount total;

  Divisions({
    required this.female,
    required this.male,
    required this.total,
  });

  factory Divisions.fromJson(Map<String, dynamic> json) {
    return Divisions(
      female: DivisionCount.fromJson(Map<String, dynamic>.from(json['female'])),
      male: DivisionCount.fromJson(Map<String, dynamic>.from(json['male'])),
      total: DivisionCount.fromJson(Map<String, dynamic>.from(json['total'])),
    );
  }
}

@HiveType(typeId: 5)
class Centre extends HiveObject {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String registered;

  @HiveField(3)
  final String sat;

  @HiveField(4)
  final String noca;

  @HiveField(5)
  final String withheld;

  @HiveField(6)
  final String clean;

  @HiveField(7)
  final String pass;

  @HiveField(8)
  final String gpa;

  @HiveField(9)
  final String grade;

  Centre({
    required this.code,
    required this.name,
    required this.registered,
    required this.sat,
    required this.noca,
    required this.withheld,
    required this.clean,
    required this.pass,
    required this.gpa,
    required this.grade,
  });

  factory Centre.fromJson(Map<String, dynamic> json) {
    return Centre(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      registered: json['registered']?.toString() ?? '',
      sat: json['sat']?.toString() ?? '',
      noca: json['noca']?.toString() ?? '',
      withheld: json['withheld']?.toString() ?? '',
      clean: json['clean']?.toString() ?? '',
      pass: json['pass']?.toString() ?? '',
      gpa: json['gpa']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
    );
  }
}

@HiveType(typeId: 6)
class Subject extends HiveObject {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String grade;

  Subject({
    required this.code,
    required this.grade,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      code: json['code']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
    );
  }
}

@HiveType(typeId: 7)
class StudentResult extends HiveObject {
  @HiveField(0)
  final String studentId;

  @HiveField(1)
  final String sex;

  @HiveField(2)
  final String aggregate;

  @HiveField(3)
  final String division;

  @HiveField(4)
  final List<Subject> subjects;

  StudentResult({
    required this.studentId,
    required this.sex,
    required this.aggregate,
    required this.division,
    required this.subjects,
  });

  factory StudentResult.fromJson(Map<String, dynamic> json) {
    return StudentResult(
      studentId: json['studentId']?.toString() ?? '',
      sex: json['sex']?.toString() ?? '',
      aggregate: json['aggregate']?.toString() ?? '',
      division: json['division']?.toString() ?? '',
      subjects: (json['subjects'] as List).map((x) => Subject.fromJson(Map<String, dynamic>.from(x))).toList(),
    );
  }
}
