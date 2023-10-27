import 'package:flutter_dotenv/flutter_dotenv.dart';

final class AppConfig {
  static String get environment => dotenv.get('ENV');
  static String get baseApiUrl => dotenv.get('BASE_API_URL');
}
