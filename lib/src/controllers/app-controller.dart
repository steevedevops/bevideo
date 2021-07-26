import 'package:bestapp_package/bestapp_package.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:setgo/assets/styles/colors.dart';
import 'package:setgo/assets/styles/style.dart';

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
          statusBarColor: c == "dark" ? AppColorDark.darkPrimary : AppColorLight.lightColor01,
          statusBarIconBrightness: c == "dark" ? Brightness.light: Brightness.light,
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
    String r = prefs.getString("theme") == null ? "light" : prefs.getString("theme");

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