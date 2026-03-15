import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class UserModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double weight;
  @HiveField(2)
  final double height;
  @HiveField(3)
  final int age;
  @HiveField(4)
  final String units;
  @HiveField(5)
  final String fitnessGoal;

  const UserModel({
    required this.name,
    required this.weight,
    required this.height,
    required this.age,
    this.units = 'kg',
    this.fitnessGoal = 'Build stamina',
  });

  UserModel copyWith({
    String? name,
    double? weight,
    double? height,
    int? age,
    String? units,
    String? fitnessGoal,
  }) {
    return UserModel(
      name: name ?? this.name,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      units: units ?? this.units,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
    );
  }
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 2;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return UserModel(
      name: fields[0] as String,
      weight: fields[1] as double,
      height: fields[2] as double,
      age: fields[3] as int,
      units: fields[4] as String? ?? 'kg',
      fitnessGoal: fields[5] as String? ?? 'Build stamina',
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.units)
      ..writeByte(5)
      ..write(obj.fitnessGoal);
  }
}
