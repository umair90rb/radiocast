import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'style.dart';
import 'routes.dart';
import 'utility/read_write_file.dart';
import 'models/User.dart';
import 'global.dart' as global;

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var fileContent = await ReadWriteFile().readData();
      if(fileContent != null ){
        global.isLoggedIn = true;
        global.user = User.fromJson(jsonDecode(fileContent));
      }
      runApp(Sunshine());
    }
  } on SocketException catch (_) {
    global.noInternet = true;
    runApp(Sunshine());
  }



}

class Sunshine extends StatefulWidget {

  @override
  _SunshineState createState() => _SunshineState();
}

class _SunshineState extends State<Sunshine> {


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void _showNotification() async {
    await _demoNotification();
  }

  Future<void> _demoNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, 'Hello, buddy',
        'A message from flutter buddy', platformChannelSpecifics,
        payload: 'test oayload');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: ');
      var re = jsonDecode(payload);


      print(re['thumbnail']);
    }
  }

  Future onDidReceiveLocalNotification(

      int id, String title, String body, String payload) async {
    print('abc');
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
               print(payload);
              },
            )
          ],
        ));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Podcast',
      theme: theme,
      routes: routes,
      // home: SingleAudio('1', 'Title', 'SheepKiller', '4kradiopodcast.com/api/file/read.php?file=intheninetees.mp3', 'https://4kradiopodcast.com/upload1/', '45521558456322155'),
      initialRoute: global.noInternet == true  ? '/noInternet' : global.isLoggedIn == true ? '/podcasts': '/signIn',
    );
  }
}
