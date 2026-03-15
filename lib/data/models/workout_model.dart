import 'package:hive/hive.dart';


@HiveType(typeId: 1)
class WorkoutModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final int durationMinutes;
  @HiveField(3)
  final int calories;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final String notes;

  const WorkoutModel({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.calories,
    required this.date,
    this.notes = '',
  });

  WorkoutModel copyWith({
    String? id,
    String? type,
    int? durationMinutes,
    int? calories,
    DateTime? date,
    String? notes,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      calories: calories ?? this.calories,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}

class WorkoutModelAdapter extends TypeAdapter<WorkoutModel> {
  @override
  final int typeId = 1;

  @override
  WorkoutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return WorkoutModel(
      id: fields[0] as String,
      type: fields[1] as String,
      durationMinutes: fields[2] as int,
      calories: fields[3] as int,
      date: fields[4] as DateTime,
      notes: fields[5] as String? ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.durationMinutes)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.notes);
  }
}
