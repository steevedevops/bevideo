import 'package:bevideo/config.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
class AppStyle{

  static String appName = Config.APP_NAME;
  static String fontFamily = 'Poppins';
  
  static ThemeData lightTheme = ThemeData(
    fontFamily: fontFamily,
    primarySwatch: createMaterialColor(Color(0xFF242f40)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: AppColorLight.lightColor01,
    // 
    backgroundColor: AppColorLight.lightColor04,
    accentColor:  AppColorLight.lightColor06,
    canvasColor: AppColorLight.lightColor03,
    scaffoldBackgroundColor: AppColorLight.lightColor03,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: AppColorLight.lightColor01,
          fontSize: 20
        ),
      )
    ),
    buttonColor: AppColorLight.lightColor02
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    backgroundColor: AppColorDark.darkBG,
    primaryColor: AppColorDark.darkPrimary,
    // accentColor: AppColorDark.darkAccent,
    scaffoldBackgroundColor: AppColorDark.darkBG,
  );
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}