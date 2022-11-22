import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController textEditingController = TextEditingController();
  int sec = 60;
  @override
  void initState() {
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
                onPressed: ()  async {
                            bool isallowed = await AwesomeNotifications().isNotificationAllowed();
                            if (!isallowed) {
                              //no permission of local notification
                             await AwesomeNotifications().requestPermissionToSendNotifications();
                            }else{
                                //show notification
                                  await  AwesomeNotifications().createNotification(
                                    content: NotificationContent( //simgple notification
                                        id: 123,
                                        channelKey: 'basic', //set configuration wuth key "basic"
                                        title: 'Welcome to FlutterCampus.com',
                                        body: 'This simple notification with action buttons in Flutter App',
                                        payload: {'name':'FlutterCampus'},
                                        autoDismissible: false,
                                    ),

                                    actionButtons: [
                                        NotificationActionButton(
                                          key: 'open', 
                                          label: 'Open File',
                                        ),

                                        NotificationActionButton(
                                          key: 'delete', 
                                          label: 'Delete File',
                                        )
                                    ]
                                );
                           }
                      }, 
                child: Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
