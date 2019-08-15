import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Constants {
  static final colors = _ColorValues();
  static final theme = _Theme();
  static final url = _Urls();
}

class _Urls {
  static final _baseUrl = "http://localhost:8080";

  final login = "$_baseUrl/login";
  final signUp = "$_baseUrl/signUp";
  final jogs = "$_baseUrl/jogs";
}

class _ColorValues {
  final darkGray = Color(0xFF454545);
  final lightGray = Color(0xFF7B7B7B);
}

class _Theme {
  final appTitle = TextStyle(fontSize: 72.0, color: Constants.colors.darkGray, fontFamily: "Futura-Bold");
  final title = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Constants.colors.darkGray, fontFamily: "SF UI Display");
  final subtitle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Constants.colors.darkGray, fontFamily: "SF UI Display");
  final onboardingText = TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal, color: Constants.colors.darkGray, fontFamily: "SF UI Display");
  final standardText = TextStyle(fontSize: 12.0, fontStyle: FontStyle.normal, color: Constants.colors.darkGray, fontFamily: "SF UI Display");

 final themeData = CupertinoThemeData(
   textTheme: CupertinoTextThemeData(
      navLargeTitleTextStyle: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Constants.colors.darkGray, fontFamily: "SF UI Display"),
      navTitleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Constants.colors.darkGray, fontFamily: "SF UI Display"),
      actionTextStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Constants.colors.darkGray, fontFamily: "SF UI Display"),
      textStyle: TextStyle(fontSize: 12.0,fontStyle: FontStyle.normal, color: Constants.colors.darkGray, fontFamily: "SF UI Display")
    )
 );
}

