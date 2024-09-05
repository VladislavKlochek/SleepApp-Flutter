import 'package:hive/hive.dart';

part 'Note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final DateTime? date;
  @HiveField(1)
  final String? noteName;
  @HiveField(2)
  final String? text;

  Note({
    required this.date,
    required this.noteName,
    required this.text,
  });
}
