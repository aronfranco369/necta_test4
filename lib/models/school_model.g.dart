// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolAdapter extends TypeAdapter<School> {
  @override
  final int typeId = 0;

  @override
  School read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return School(
      school: fields[0] as SchoolInfo,
      students: (fields[1] as List).cast<StudentStats>(),
      divisions: fields[2] as Divisions,
      centre: (fields[3] as List).cast<Centre>(),
      results: (fields[4] as List).cast<StudentResult>(),
    );
  }

  @override
  void write(BinaryWriter writer, School obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.school)
      ..writeByte(1)
      ..write(obj.students)
      ..writeByte(2)
      ..write(obj.divisions)
      ..writeByte(3)
      ..write(obj.centre)
      ..writeByte(4)
      ..write(obj.results);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SchoolInfoAdapter extends TypeAdapter<SchoolInfo> {
  @override
  final int typeId = 1;

  @override
  SchoolInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolInfo(
      id: fields[0] as String,
      name: fields[1] as String,
      url: fields[2] as String,
      region: fields[3] as String,
      passed: fields[4] as String,
      gpa: fields[5] as String,
      grade: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.region)
      ..writeByte(4)
      ..write(obj.passed)
      ..writeByte(5)
      ..write(obj.gpa)
      ..writeByte(6)
      ..write(obj.grade);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudentStatsAdapter extends TypeAdapter<StudentStats> {
  @override
  final int typeId = 2;

  @override
  StudentStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentStats(
      registered: fields[0] as String,
      absent: fields[1] as String,
      sat: fields[2] as String,
      withheld: fields[3] as String,
      noca: fields[4] as String,
      clean: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentStats obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.registered)
      ..writeByte(1)
      ..write(obj.absent)
      ..writeByte(2)
      ..write(obj.sat)
      ..writeByte(3)
      ..write(obj.withheld)
      ..writeByte(4)
      ..write(obj.noca)
      ..writeByte(5)
      ..write(obj.clean);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DivisionCountAdapter extends TypeAdapter<DivisionCount> {
  @override
  final int typeId = 3;

  @override
  DivisionCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DivisionCount(
      divI: fields[0] as int,
      divII: fields[1] as int,
      divIII: fields[2] as int,
      divIV: fields[3] as int,
      div0: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DivisionCount obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.divI)
      ..writeByte(1)
      ..write(obj.divII)
      ..writeByte(2)
      ..write(obj.divIII)
      ..writeByte(3)
      ..write(obj.divIV)
      ..writeByte(4)
      ..write(obj.div0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DivisionCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DivisionsAdapter extends TypeAdapter<Divisions> {
  @override
  final int typeId = 4;

  @override
  Divisions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Divisions(
      female: fields[0] as DivisionCount,
      male: fields[1] as DivisionCount,
      total: fields[2] as DivisionCount,
    );
  }

  @override
  void write(BinaryWriter writer, Divisions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.female)
      ..writeByte(1)
      ..write(obj.male)
      ..writeByte(2)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DivisionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CentreAdapter extends TypeAdapter<Centre> {
  @override
  final int typeId = 5;

  @override
  Centre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Centre(
      code: fields[0] as String,
      name: fields[1] as String,
      registered: fields[2] as String,
      sat: fields[3] as String,
      noca: fields[4] as String,
      withheld: fields[5] as String,
      clean: fields[6] as String,
      pass: fields[7] as String,
      gpa: fields[8] as String,
      grade: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Centre obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.registered)
      ..writeByte(3)
      ..write(obj.sat)
      ..writeByte(4)
      ..write(obj.noca)
      ..writeByte(5)
      ..write(obj.withheld)
      ..writeByte(6)
      ..write(obj.clean)
      ..writeByte(7)
      ..write(obj.pass)
      ..writeByte(8)
      ..write(obj.gpa)
      ..writeByte(9)
      ..write(obj.grade);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CentreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 6;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      code: fields[0] as String,
      grade: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.grade);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudentResultAdapter extends TypeAdapter<StudentResult> {
  @override
  final int typeId = 7;

  @override
  StudentResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentResult(
      studentId: fields[0] as String,
      sex: fields[1] as String,
      aggregate: fields[2] as String,
      division: fields[3] as String,
      subjects: (fields[4] as List).cast<Subject>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudentResult obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.sex)
      ..writeByte(2)
      ..write(obj.aggregate)
      ..writeByte(3)
      ..write(obj.division)
      ..writeByte(4)
      ..write(obj.subjects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
