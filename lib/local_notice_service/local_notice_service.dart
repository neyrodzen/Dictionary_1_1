import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../data_base/data_base.dart';

class LocalNoticeService {
  LocalNoticeService();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    final androidSetting =
        AndroidInitializationSettings('@drawable/ic_stat_word_of_day');
    final iosSetting = IOSInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
        onDidReceiveLocalNotification: _onDidRecievelocalNotification);
    final initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    await _localNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future<void> swowNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationsPlugin.show(id, title, body, details);
  }

  static int count = 0;
  Future<void> swowSceduledNotification({
    required int id,
    required int second,
    
  }) async {
    Map<String, String> map = await getWords();
    String title = map.keys.first;
    String body = map.values.first;
    final details = await _notificationDetails();
    await _localNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.hourly,
      details,
      androidAllowWhileIdle: true,
    );
    count++;
  }

  Future<void> swowNotificationWithPayload({
    required int id,
    required int second,
    required String payload,
  }) async {
    Map<String, String> map = await getWords();
    String title = map.keys.first;
    String body = map.values.first;
    final details = await _notificationDetails();
    await _localNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
            DateTime.now().add(Duration(seconds: second)), tz.local),
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
        count++;
  }

  Future<Map<String, String>> getWords() async {
    int index = count;
    DataBase database = DataBase();
    return await database.getListLearn(index);
  }

  void _onDidRecievelocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}
