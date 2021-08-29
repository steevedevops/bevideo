import 'package:flutter/material.dart';
import 'src/screens/navigator.dart';
import 'src/screens/welcome.dart';

class RouterBeVideo {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      
      case '/homebase':
        int defineScreen = args as int;
        return MaterialPageRoute(builder: (_) => NavigatorBar(defineScreen: defineScreen));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        // appBar: SimpleAppBar(
        //   leadingIcon: CustomIcons.back,
        //   onLeadingPressed: (){
        //     Navigator.pop(_);
        //   },
        // ),
        // body: Center(
        //   child: Container(
        //     padding: EdgeInsets.all(20.0),
        //     child: SvgPicture.asset(
        //       'lib/assets/images/page_not_found.svg',
        //       width: 210,
        //     ),
        //   ),
        // ),
      );
    });
  }
}