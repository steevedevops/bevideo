import 'dart:async';
import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/assets/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<WelcomeScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void nextScreen() async {
    Future.delayed(Duration(seconds: 3),() {
        Navigator.pushReplacementNamed(context, '/homebase');
      }
    );
  }

  @override
  void initState() {
    super.initState();
    nextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [Theme.of(context).primaryColor, Theme.of(context).canvasColor],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     )
          // ),
          color: Theme.of(context).backgroundColor,
          // decoration: BoxDecoration(
          //   color: Color(0xff2B3242)
          //   // gradient: LinearGradient(
          //   //   // colors: [Color(0xffE2E3E5), Color(0xff2B3241)],
          //   //   colors: [Color(0xff283242),Color(0xff283242)],
          //   //   begin: Alignment.topLeft,
          //   //   end: Alignment.bottomRight,
          //   // )
          // ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left:1.0),
                  child: SvgPicture.asset(
                    'lib/assets/logos/logo.svg',
                    // width: 24,
                  ),
                ),
                SizedBox(width: 40.0),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: 15.0,
                  ),
                  child:  Container(
                    child: Text('${AppStyle.appName}',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: AppStyle.fontFamily,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).accentColor
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}