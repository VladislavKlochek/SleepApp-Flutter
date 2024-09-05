import 'package:hive/hive.dart';

part 'alarm_info.g.dart';

@HiveType(typeId: 1)
class AlarmInfo {
  @HiveField(0)
  String time;
  @HiveField(1)
  String description;
  @HiveField(2)
  bool isActive; // Make sure isActive is of type bool
  @HiveField(3)
  bool isSound; // Make sure isActive is of type bool
  @HiveField(4)
  bool isVibration; // Make sure isActive is of type bool
  @HiveField(5)
  int id; // Make sure isActive is of type bool
  @HiveField(6)
  String soundName;

  AlarmInfo({
    required this.time,
    required this.description,
    required this.isActive,
    required this.isSound,
    required this.isVibration,
    required this.id,
    required this.soundName,});

  get key => null;
}