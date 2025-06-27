// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // シングルトンパターン: アプリ内で常に唯一のインスタンスを保証する
  NotificationService._();
  static final instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // 初期化メソッド
  Future<void> init() async {
    // Android用の初期化設定
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ); // @mipmap/ic_launcher はデフォルトのアイコン

    // iOS用の初期化設定
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // 初期化設定を統合
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // プラグインを初期化
    await _plugin.initialize(settings);

    // Android 13以降の通知権限をリクエスト
    _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // ポモドーロ完了通知を表示するメソッド
  void showPomodoroCompletionNotification() {
    // Android用の通知詳細設定
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'pomodoro_channel', // チャンネルID
          'Pomodoro Notifications', // チャンネル名
          channelDescription:
              'Notifications for Pomodoro completion', // チャンネルの説明
          importance: Importance.max,
          priority: Priority.high,
        );

    // iOS用の通知詳細設定
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // 通知詳細を統合
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 通知を表示
    _plugin.show(
      0, // 通知ID
      'ポモドーロ完了！', // タイトル
      'お疲れ様でした。少し休憩しましょう。', // 本文
      notificationDetails,
    );
  }
}
