import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class GoalModel {
  @HiveField(0)
  final int stepsGoal;
  @HiveField(1)
  final int caloriesGoal;
  @HiveField(2)
  final int workoutsGoal;

  const GoalModel({
    required this.stepsGoal,
    required this.caloriesGoal,
    required this.workoutsGoal,
  });

  GoalModel copyWith({
    int? stepsGoal,
    int? caloriesGoal,
    int? workoutsGoal,
  }) {
    return GoalModel(
      stepsGoal: stepsGoal ?? this.stepsGoal,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      workoutsGoal: workoutsGoal ?? this.workoutsGoal,
    );
  }
}

class GoalModelAdapter extends TypeAdapter<GoalModel> {
  @override
  final int typeId = 3;

  @override
  GoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return GoalModel(
      stepsGoal: fields[0] as int,
      caloriesGoal: fields[1] as int,
      workoutsGoal: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GoalModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.stepsGoal)
      ..writeByte(1)
      ..write(obj.caloriesGoal)
      ..writeByte(2)
      ..write(obj.workoutsGoal);
  }
}
