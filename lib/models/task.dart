import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  // タスクのタイトル
  @HiveField(0)
  String title;

  // ポモドーロの完了数
  @HiveField(1)
  int completedPomodoros;

  // 目標ポモドーロ数
  @HiveField(2)
  int targetPomodoros;

  // タスクのコンストラクタ
  Task({
    required this.title,
    this.completedPomodoros = 0,
    this.targetPomodoros = 4,
  });
}
