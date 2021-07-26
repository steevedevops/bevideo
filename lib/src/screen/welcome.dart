import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<WelcomeScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void nextScreen() async {
    SharedPreferences prefs = await _prefs;
    Future.delayed(Duration(seconds: 3),() {
        if(prefs.containsKey('sessionid') && prefs.getString('sessionid') != null){
          // Navigator.pushReplacementNamed(context, '/homebase');
        }else{
          Navigator.pushReplacementNamed(context, '/login');
          // Navigator.pushReplacementNamed(context, '/homeauth');
          // Navigator.pushReplacementNamed(context, '/');
        }
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
          color: Theme.of(context).primaryColor,
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
                // Padding(
                //   padding: const EdgeInsets.all(100.0),
                //   child: Container(
                //     height: 180,
                //     child: new Image.asset(
                //       'lib/assets/logo/animation_640_kp8b8fxv.gif',
                //       width: 100.0,
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                // ),
                SizedBox(width: 40.0)
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: 15.0,
                  ),
                  child: Text(
                    "${AppStyle.appName}",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}