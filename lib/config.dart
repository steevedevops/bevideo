import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
const bool isProduction = bool.fromEnvironment('dart.vm.product');

class Config{
  static String get PRD_URL{
    return DotEnv.env['PRD_URL'];
  }
  static String get DEV_URL{
    return DotEnv.env['DEV_URL'];
  }
  static String get APP_NAME{
    return DotEnv.env['APP_NAME'];
  }
  static String get BASE_URL{
    return isProduction ? DotEnv.env['PRD_URL'] : DotEnv.env['DEV_URL'];
  }
  static String get GOOGLE_MAP_API_KEY{
    return DotEnv.env['GOOGLE_MAP_API_KEY'];
  }
}