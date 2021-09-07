import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/assets/styles/colors.dart';
import 'package:bevideo/assets/styles/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppController extends ChangeNotifier{
  AppController(){
    checkTheme();
  }

  ThemeData theme = AppStyle.lightTheme;
  Key key = UniqueKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void setKey(value) {
    key = value;
    notifyListeners();
  }

  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }

  void setTheme(value, c) {
    theme = value;
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("theme", c).then((val){
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: c == "dark" ? AppColorDark.darkPrimary : AppColorLight.primaryColor,
          // statusBarIconBrightness: c == "dark" ? Brightness.light :Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ));
      });
    });
    notifyListeners();
  }

  ThemeData getTheme(value) {
    return theme;
  }

  Future<ThemeData> checkTheme() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeData t;
    String r = prefs.getString("theme") == null ? "light" : prefs.getString(
        "theme");

    if(r == "light"){
      t = AppStyle.lightTheme;
      setTheme(AppStyle.lightTheme, "light");
    }else{
      t = AppStyle.darkTheme;
      setTheme(AppStyle.darkTheme, "dark");
    }

    return t;
  }
}

final appController = ChangeNotifierProvider<AppController>((ref){
  return AppController();
});