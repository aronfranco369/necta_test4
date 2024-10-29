import 'package:hive/hive.dart';

part 'qt_model.g.dart';

@HiveType(typeId: 8)
class SchoolQt extends HiveObject {
  @HiveField(0)
  final SchoolInfoQt school;

  @HiveField(1)
  final DivisionsQt divisions;

  @HiveField(2)
  final List<StudentResultQt> results;

  SchoolQt({
    required this.school,
    required this.divisions,
    required this.results,
  });

  factory SchoolQt.fromJson(dynamic json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(json);
    return SchoolQt(
      school: SchoolInfoQt.fromJson(Map<String, dynamic>.from(data['school'])),
      divisions: DivisionsQt.fromJson(Map<String, dynamic>.from(data['divisions'])),
      results: (data['results'] as List).map((x) => StudentResultQt.fromJson(Map<String, dynamic>.from(x))).toList(),
    );
  }
}

@HiveType(typeId: 9)
class SchoolInfoQt extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String url;

  SchoolInfoQt({
    required this.id,
    required this.name,
    required this.url,
  });

  factory SchoolInfoQt.fromJson(Map<String, dynamic> json) {
    return SchoolInfoQt(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }
}

@HiveType(typeId: 10)
class DivisionCountQt extends HiveObject {
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

  DivisionCountQt({
    required this.divI,
    required this.divII,
    required this.divIII,
    required this.divIV,
    required this.div0,
  });

  factory DivisionCountQt.fromJson(Map<String, dynamic> json) {
    return DivisionCountQt(
      divI: int.tryParse(json['I']?.toString() ?? '0') ?? 0,
      divII: int.tryParse(json['II']?.toString() ?? '0') ?? 0,
      divIII: int.tryParse(json['III']?.toString() ?? '0') ?? 0,
      divIV: int.tryParse(json['IV']?.toString() ?? '0') ?? 0,
      div0: int.tryParse(json['0']?.toString() ?? '0') ?? 0,
    );
  }
}

@HiveType(typeId: 11)
class DivisionsQt extends HiveObject {
  @HiveField(0)
  final DivisionCountQt female;

  @HiveField(1)
  final DivisionCountQt male;

  @HiveField(2)
  final DivisionCountQt total;

  DivisionsQt({
    required this.female,
    required this.male,
    required this.total,
  });

  factory DivisionsQt.fromJson(Map<String, dynamic> json) {
    return DivisionsQt(
      female: DivisionCountQt.fromJson(Map<String, dynamic>.from(json['female'])),
      male: DivisionCountQt.fromJson(Map<String, dynamic>.from(json['male'])),
      total: DivisionCountQt.fromJson(Map<String, dynamic>.from(json['total'])),
    );
  }
}

@HiveType(typeId: 12)
class SubjectQt extends HiveObject {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String grade;

  SubjectQt({
    required this.code,
    required this.grade,
  });

  factory SubjectQt.fromJson(Map<String, dynamic> json) {
    return SubjectQt(
      code: json['code']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
    );
  }
}

@HiveType(typeId: 13)
class StudentResultQt extends HiveObject {
  @HiveField(0)
  final String studentId;

  @HiveField(1)
  final String sex;

  @HiveField(2)
  final String aggregate;

  @HiveField(3)
  final String division;

  @HiveField(4)
  final List<SubjectQt> subjects;

  StudentResultQt({
    required this.studentId,
    required this.sex,
    required this.aggregate,
    required this.division,
    required this.subjects,
  });

  factory StudentResultQt.fromJson(Map<String, dynamic> json) {
    return StudentResultQt(
      studentId: json['studentId']?.toString() ?? '',
      sex: json['sex']?.toString() ?? '',
      aggregate: json['aggregate']?.toString() ?? '',
      division: json['division']?.toString() ?? '',
      subjects: (json['subjects'] as List).map((x) => SubjectQt.fromJson(Map<String, dynamic>.from(x))).toList(),
    );
  }
}
