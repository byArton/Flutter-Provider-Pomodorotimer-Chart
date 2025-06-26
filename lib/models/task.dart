import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  int completedPomodoros;

  @HiveField(2)
  int targetPomodoros;

  Task({
    required this.title,
    this.completedPomodoros = 0,
    this.targetPomodoros = 4,
  });
}
