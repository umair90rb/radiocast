import 'package:flutter/material.dart';

final theme = ThemeData(
    fontFamily: 'Roboto',
    buttonColor: Color(0xff193b6a),
    brightness: Brightness.light,
    accentColor: Colors.red,
    primarySwatch: Colors.blue,
    primaryColor: Color(0xff193b6a),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      button: TextStyle(
          fontSize: 14, color: Colors.white),
      headline: TextStyle(fontSize: 24,),
      title: TextStyle(
        fontSize: 18,

      ),
      subtitle: TextStyle(
        fontSize: 16,
      ),
      body1: TextStyle(fontSize: 12),
      body2: TextStyle(fontSize: 10),
      caption: TextStyle(fontSize: 10, color: Colors.grey),
    ));
