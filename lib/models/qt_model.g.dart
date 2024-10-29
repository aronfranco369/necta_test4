// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolQtAdapter extends TypeAdapter<SchoolQt> {
  @override
  final int typeId = 8;

  @override
  SchoolQt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolQt(
      school: fields[0] as SchoolInfoQt,
      divisions: fields[1] as DivisionsQt,
      results: (fields[2] as List).cast<StudentResultQt>(),
    );
  }

  @override
  void write(BinaryWriter writer, SchoolQt obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.school)
      ..writeByte(1)
      ..write(obj.divisions)
      ..writeByte(2)
      ..write(obj.results);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolQtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SchoolInfoQtAdapter extends TypeAdapter<SchoolInfoQt> {
  @override
  final int typeId = 9;

  @override
  SchoolInfoQt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolInfoQt(
      id: fields[0] as String,
      name: fields[1] as String,
      url: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolInfoQt obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolInfoQtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DivisionCountQtAdapter extends TypeAdapter<DivisionCountQt> {
  @override
  final int typeId = 10;

  @override
  DivisionCountQt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DivisionCountQt(
      divI: fields[0] as int,
      divII: fields[1] as int,
      divIII: fields[2] as int,
      divIV: fields[3] as int,
      div0: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DivisionCountQt obj) {
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
      other is DivisionCountQtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DivisionsQtAdapter extends TypeAdapter<DivisionsQt> {
  @override
  final int typeId = 11;

  @override
  DivisionsQt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DivisionsQt(
      female: fields[0] as DivisionCountQt,
      male: fields[1] as DivisionCountQt,
      total: fields[2] as DivisionCountQt,
    );
  }

  @override
  void write(BinaryWriter writer, DivisionsQt obj) {
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
      other is DivisionsQtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectQtAdapter extends TypeAdapter<SubjectQt> {
  @override
  final int typeId = 12;

  @override
  SubjectQt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectQt(
      code: fields[0] as String,
      grade: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectQt obj) {
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
      other is SubjectQtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudentResultQtAdapter extends TypeAdapter<StudentResultQt> {
  @override
  final int typeId = 13;

  @override
  StudentResultQt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentResultQt(
      studentId: fields[0] as String,
      sex: fields[1] as String,
      aggregate: fields[2] as String,
      division: fields[3] as String,
      subjects: (fields[4] as List).cast<SubjectQt>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudentResultQt obj) {
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
      other is StudentResultQtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
