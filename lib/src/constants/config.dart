import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String googlePlatformApiKey = dotenv.get('GOOGLE_PLATFORM_API_KEY');

  static init() async {
    await dotenv.load(fileName: ".env");
  }
}
