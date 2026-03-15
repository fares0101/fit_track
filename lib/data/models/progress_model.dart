import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class ProgressModel {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final double weight;
  @HiveField(2)
  final int caloriesBurned;
  @HiveField(3)
  final int activeMinutes;
  @HiveField(4)
  final int steps;

  const ProgressModel({
    required this.date,
    required this.weight,
    required this.caloriesBurned,
    required this.activeMinutes,
    required this.steps,
  });
}

class ProgressModelAdapter extends TypeAdapter<ProgressModel> {
  @override
  final int typeId = 4;

  @override
  ProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return ProgressModel(
      date: fields[0] as DateTime,
      weight: fields[1] as double,
      caloriesBurned: fields[2] as int,
      activeMinutes: fields[3] as int,
      steps: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.caloriesBurned)
      ..writeByte(3)
      ..write(obj.activeMinutes)
      ..writeByte(4)
      ..write(obj.steps);
  }
}
