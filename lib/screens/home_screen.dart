// import 'package:flutter/material.dart';
// import 'package:flutter_provider_pomodorotimer_chart/widgets/timer_circle.dart';
// import 'package:provider/provider.dart';

// import '../models/task.dart';
// import '../providers/task_provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _timer = 25 * 60;
//   bool _isRunning = false;
//   late Task? _selectedTask;

//   @override
//   void initState() {
//     super.initState();
//     _selectedTask = null;
//   }

//   void _startTimer(TaskProvider provider) {
//     if (_isRunning) return;
//     _isRunning = true;
//     setState(() {});
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(seconds: 1));
//       if (!_isRunning || _timer == 0) return false;
//       setState(() => _timer--);
//       if (_timer == 0 && _selectedTask != null) {
//         provider.incrementPomodoro(_selectedTask!);
//         _isRunning = false;
//         _timer = 25 * 60;
//       }
//       return _isRunning;
//     });
//   }

//   void _stopTimer() {
//     _isRunning = false;
//     setState(() {});
//   }

//   String _formatTime(int totalSeconds) {
//     final min = (totalSeconds ~/ 60).toString().padLeft(2, '0');
//     final sec = (totalSeconds % 60).toString().padLeft(2, '0');
//     return '$min:$sec';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<TaskProvider>(context);
//     final int totalSeconds = 25 * 60;
//     final double progress = 1.0 - (_timer / totalSeconds);

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // ↓ここから変更
//             TimerCircle(timer: _timer, totalSeconds: 25 * 60),
//             const SizedBox(height: 16),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
//                   label: Text(_isRunning ? '一時停止' : 'スタート'),
//                   onPressed: () {
//                     if (_isRunning) {
//                       _stopTimer();
//                     } else {
//                       _startTimer(provider);
//                     }
//                   },
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.restore),
//                   label: const Text('リセット'),
//                   onPressed: () {
//                     setState(() => _timer = 25 * 60);
//                     _stopTimer();
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }
// }

// home_screen.dart
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
  int _timer = PomodoroConfig.pomodoroSeconds;
  bool _isRunning = false;
  late Task? _selectedTask;
  bool _animateKey = false;

  @override
  void initState() {
    super.initState();
    _selectedTask = null;
  }

  void _toggleAnimateKey() {
    setState(() {
      _animateKey = !_animateKey;
    });
  }

  void _startTimer(TaskProvider provider) {
    if (_isRunning) return;
    _isRunning = true;
    _toggleAnimateKey(); // スタート時アニメ
    setState(() {});
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isRunning || _timer == 0) return false;
      setState(() => _timer--);
      if (_timer == 0 && _selectedTask != null) {
        provider.incrementPomodoro(_selectedTask!);
        _isRunning = false;
        _timer = PomodoroConfig.pomodoroSeconds;
      }
      return _isRunning;
    });
  }

  void _stopTimer() {
    _isRunning = false;
    setState(() {});
  }

  void _resetTimer() {
    setState(() => _timer = PomodoroConfig.pomodoroSeconds);
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
              timer: _timer,
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
