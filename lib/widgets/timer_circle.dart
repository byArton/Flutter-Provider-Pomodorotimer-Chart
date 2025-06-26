// import 'package:flutter/material.dart';

// class TimerCircle extends StatelessWidget {
//   final int timer; // 残り秒数
//   final int totalSeconds; // タイマー合計秒数

//   const TimerCircle({
//     super.key,
//     required this.timer,
//     required this.totalSeconds,
//   });

//   String _formatTime(int totalSeconds) {
//     final min = (totalSeconds ~/ 60).toString().padLeft(2, '0');
//     final sec = (totalSeconds % 60).toString().padLeft(2, '0');
//     return '$min:$sec';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double progress = 1.0 - (timer / totalSeconds);
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Transform(
//           alignment: Alignment.center,
//           transform: Matrix4.rotationY(3.14159), // 反時計回り
//           child: SizedBox(
//             width: 250,
//             height: 250,
//             child: CircularProgressIndicator(
//               value: progress,
//               strokeWidth: 20,
//               backgroundColor: Colors.grey.shade300,
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD3414A)),
//             ),
//           ),
//         ),
//         Text(
//           _formatTime(timer),
//           style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

class TimerCircle extends StatefulWidget {
  final int timer; // 残り秒数
  final int totalSeconds; // タイマー合計秒数
  final bool animateKey; // アニメーション用のkey

  const TimerCircle({
    super.key,
    required this.timer,
    required this.totalSeconds,
    required this.animateKey,
  });

  @override
  State<TimerCircle> createState() => _TimerCircleState();
}

class _TimerCircleState extends State<TimerCircle> {
  late double oldProgress;
  late double newProgress;

  @override
  void initState() {
    super.initState();
    newProgress = 1.0 - (widget.timer / widget.totalSeconds);
    oldProgress = newProgress;
  }

  @override
  void didUpdateWidget(covariant TimerCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldProgress = newProgress;
    newProgress = 1.0 - (widget.timer / widget.totalSeconds);
  }

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(widget.animateKey.toString() + widget.timer.toString()),
      tween: Tween<double>(begin: oldProgress, end: newProgress),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.14159), // 反時計回り
              child: SizedBox(
                width: 250,
                height: 250,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 20,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFCA3836)),
                ),
              ),
            ),
            Text(
              _formatTime(widget.timer),
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.white,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
