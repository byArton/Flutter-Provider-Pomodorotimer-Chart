// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_provider_pomodorotimer_chart/services/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  // アプリ起動時にHiveを初期化
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationServiceを初期化
  await NotificationService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // タスクモデルのアダプターを登録
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFCA3836)),
          useMaterial3: true,
          // フォントを設定
          textTheme: GoogleFonts.economicaTextTheme(),
        ),
      ),
    );
  }
}
