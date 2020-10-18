import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static void setLocale(BuildContext context, Locale locale){
    _SunshineState state = context.findAncestorStateOfType<_SunshineState>();
    state.setLocale(locale);
  }
  @override
  _SunshineState createState() => _SunshineState();
}

class _SunshineState extends State<Sunshine> {

  Locale _locale;

  void setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RadioCast',
      theme: theme,
      routes: routes,
      initialRoute: global.noInternet == true  ? '/noInternet' : global.isLoggedIn == true ? '/home': '/signIn',
    );
  }
}
