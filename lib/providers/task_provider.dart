// task_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_provider_pomodorotimer_chart/services/notification_service.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  // ポモドーロを1つ増やす
  void incrementPomodoro() {
    NotificationService.instance.showPomodoroCompletionNotification();
    notifyListeners();
  }

  // ポモドーロをリセットする
  void resetPomodoro(Task task) {
    task.completedPomodoros = 0;
    task.save();
    notifyListeners();
  }
}
