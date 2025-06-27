// home_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_provider_pomodorotimer_chart/constants/config.dart';
import 'package:flutter_provider_pomodorotimer_chart/widgets/timer_circle.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // タイマーの状態を管理
  int _timerValue = PomodoroConfig.pomodoroSeconds;
  Timer? _timerController;
  bool _isRunning = false;
  // 選択されたタスクを管理
  late Task? _selectedTask;
  // アニメーションのキーを管理
  bool _animateKey = false;

  @override
  void initState() {
    super.initState();
    _selectedTask = null;
  }

  // アニメーションのキーを切り替える
  void _toggleAnimateKey() {
    setState(() {
      _animateKey = !_animateKey;
    });
  }

  void _startTimer(TaskProvider provider) {
    // 既にタイマーが動いていたら何もしない
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _toggleAnimateKey(); // スタート時アニメ
    });

    // 1秒ごとに実行されるタイマーを開始
    _timerController = Timer.periodic(const Duration(seconds: 1), (timer) {
      // タイマーが1秒以上残っている場合
      if (_timerValue > 0) {
        setState(() {
          _timerValue--; // 1秒減らす
        });
      }
      // タイマーが0になった場合
      else {
        _timerController?.cancel(); // タイマーを停止する

        // タスクが選択されていれば、ポモドーロを記録して通知を出す
        if (_selectedTask != null) {
          provider.incrementPomodoro();
        }

        // 状態をリセットしてUIを更新する
        setState(() {
          _isRunning = false;
          provider.incrementPomodoro();
          _timerValue = PomodoroConfig.pomodoroSeconds;
        });
      }
    });
  }

  // タイマーを停止する
  void _stopTimer() {
    _isRunning = false;
    setState(() {});
  }

  // タイマーをリセットする
  void _resetTimer() {
    setState(() => _timerValue = PomodoroConfig.pomodoroSeconds);
    _toggleAnimateKey(); // リセット時アニメ
    _stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerCircle(
              timer: _timerValue,
              totalSeconds: PomodoroConfig.pomodoroSeconds,
              animateKey: _animateKey,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? '一時停止' : 'スタート'),
                  onPressed: () {
                    if (_isRunning) {
                      _stopTimer();
                    } else {
                      _startTimer(provider);
                    }
                  },
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('リセット'),
                  onPressed: _resetTimer,
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
