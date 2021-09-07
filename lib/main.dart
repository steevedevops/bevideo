import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/assets/styles/style.dart';
import 'package:bevideo/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/controllers/app-controller.dart';
import 'src/screens/welcome.dart';


final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
void main() async{
  await DotEnv.load();
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: BeVideoApp()
    )
  );
}


class BeVideoApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final appProvider = watch(appController);
    return MaterialApp(
      key: appProvider.key,
      debugShowCheckedModeBanner: false,
      navigatorKey: appProvider.navigatorKey,
      title: AppStyle.appName,
      theme: appProvider.theme,
      darkTheme: AppStyle.darkTheme,
      initialRoute: '/',
      onGenerateRoute: RouterBeVideo.generateRoute,
      home: WelcomeScreen(),
    );
  }
}