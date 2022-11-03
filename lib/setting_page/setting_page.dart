import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../local_notice_service/local_notice_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late LocalNoticeService service;
  TextEditingController textEditingController = TextEditingController();
  int sec = 60;
  @override
  void initState() {
    service = LocalNoticeService();
    service.initialize();
    listenToNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Text(''),
            )
          ],
          title: Center(
            child: Text(
              'Settings',
            ),
          )),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: double.infinity,
          minWidth: double.infinity,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 139, 111, 186),
            Color.fromARGB(255, 184, 148, 190)
          ])),
          child: Column(
            children: [
              Text('Введите интервал в минутах'),
              TextField(
                controller: textEditingController,
              ),
              ElevatedButton(
                onPressed: () async {
                  sec = int.parse(textEditingController.text) * 60;
                  await service.swowNotificationWithPayload(
                      id: 0, second: sec, payload: 'payload');
                },
                child: Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);

  Future<void> onNotificationListener(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      await service.swowNotificationWithPayload(
          id: 0, second: sec, payload: 'payload');
    }
  }
}
