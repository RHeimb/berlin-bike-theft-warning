import 'package:flutter/material.dart';

class AppTheme {
  //Modify to add more colors here
  static ThemeData _lightThemeData = ThemeData(
    canvasColor: Colors.blueGrey[50],
    primaryColor: Colors.blueGrey[50],
    scaffoldBackgroundColor: Colors.blueGrey.shade200,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.black,
        primary: Colors.blueGrey.shade100,
        textStyle: TextStyle(
          color: Colors.black,
        ),
        // shape: CircleBorder(),
        minimumSize: Size(46, 46),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: Colors.black),
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
      size: 34,
    ),
    textTheme: TextTheme(
      button: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
      subtitle2: TextStyle(
        // Chart Text
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 8,
      ),
    ),
  );

  static ThemeData _darkThemeData = ThemeData(
    canvasColor: Colors.grey.shade900,
    primaryColor: Colors.grey.shade900,
    scaffoldBackgroundColor: Colors.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey.shade900,
        onPrimary: Colors.white,
        textStyle: TextStyle(
          color: Colors.white,
        ),
        minimumSize: Size(46, 46),
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 34,
    ),
    textTheme: TextTheme(
      button: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
      subtitle2: TextStyle(
        // Chart Text
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontSize: 8,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: Colors.white),
      ),
    ),
  );
  ThemeData getAppThemedata(BuildContext context, bool isDarkModeEnabled) {
    return isDarkModeEnabled ? _darkThemeData : _lightThemeData;
  }
}
