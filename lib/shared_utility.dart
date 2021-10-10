import 'package:flutter/material.dart';

class AppTheme {
  //Modify to add more colors here
  static ThemeData _lightThemeData = ThemeData(
    primaryColor: Colors.blueGrey[600],
    accentColor: Colors.blueGrey[100],
    buttonColor: Colors.blueGrey.shade200,
    scaffoldBackgroundColor: Colors.blueGrey.shade200,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          color: Colors.black,
        ),
        primary: Colors.blueGrey.shade200,
        shape: CircleBorder(),
        minimumSize: Size(56, 56),
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
      size: 34,
    ),
  );

  static ThemeData _darkThemeData = ThemeData(
    primaryColor: Colors.blue,
    accentColor: Colors.black12,
    buttonColor: Colors.blueGrey.shade900,
    scaffoldBackgroundColor: Colors.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          color: Colors.white,
        ),
        primary: Colors.blueGrey.shade900,
        shape: CircleBorder(),
        minimumSize: Size(56, 56),
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 34,
    ),
  );
  ThemeData getAppThemedata(BuildContext context, bool isDarkModeEnabled) {
    return isDarkModeEnabled ? _darkThemeData : _lightThemeData;
  }
}
