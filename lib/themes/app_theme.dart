import 'package:flutter/material.dart';

ThemeData DarkTheme() {
  final ThemeData darkTheme = ThemeData.dark();
  return darkTheme.copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Colors.black26,
      secondary: Colors.black45,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          color: Color.fromARGB(206, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold),
      iconTheme:
          IconThemeData(size: 30, color: Color.fromARGB(206, 255, 255, 255)),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
          color: Color.fromARGB(206, 255, 255, 255),
          fontSize: 22,
          fontWeight: FontWeight.bold),
      headline2: TextStyle(
          color: Color.fromARGB(206, 255, 255, 255),
          fontSize: 18,
          fontWeight: FontWeight.bold),
    ),
  );
}
