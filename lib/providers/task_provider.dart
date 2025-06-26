// task_provider.dart
import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  void incrementPomodoro(Task task) {
    task.completedPomodoros += 1;
    task.save();
    notifyListeners();
  }

  void resetPomodoro(Task task) {
    task.completedPomodoros = 0;
    task.save();
    notifyListeners();
  }
}
