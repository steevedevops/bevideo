import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/assets/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'src/controllers/app-controller.dart';
import 'src/screen/welcome.dart';

void main() async{
  await DotEnv.load();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppController()),
        ],
        child: BeVideoApp(),
      )
  );
}

class BeVideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (BuildContext context, AppController appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: AppStyle.appName,
          theme: appProvider.theme,
          darkTheme: AppStyle.lightTheme,
          initialRoute: '/',
          onGenerateRoute: RouterSetgo.generateRoute,
          home: WelcomeScreen(),
        );
      }
    );
  }
}