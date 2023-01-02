import 'package:flutter/material.dart';

var theme = ThemeData(//자기 자신과 쫌 더 가까운 스타일이 입혀짐
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1,
    actionsIconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.black),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black
  ),
);