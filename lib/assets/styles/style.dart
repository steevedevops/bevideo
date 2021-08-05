import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/config.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
class AppStyle{

  static String appName = Config.APP_NAME;
  static String fontFamily = 'Poppins';

  static ThemeData lightTheme = ThemeData(
    fontFamily: fontFamily,
    primarySwatch: BestappUtils.createMaterialColor(Color(0xFF242f40)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: AppColorLight.lightColor01,
    backgroundColor: AppColorLight.lightColor04,
    accentColor:  AppColorLight.lightColor06,
    canvasColor: AppColorLight.lightColor03,
    scaffoldBackgroundColor: AppColorLight.lightColor03,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: AppColorLight.lightColor01,
          fontSize: 18
        ),
      )
    ),
    buttonColor: AppColorLight.lightColor02
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    backgroundColor: AppColorDark.darkBG,
    primaryColor: AppColorDark.darkPrimary,
    accentColor: AppColorDark.darkAccent,
    scaffoldBackgroundColor: AppColorDark.darkBG,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: AppColorLight.lightColor01,
          fontSize: 18
        ),
      )
    ),
  );
}