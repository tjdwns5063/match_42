import 'package:shared_preferences/shared_preferences.dart';

class TokenApis {
  static TokenApis instance = TokenApis._();
  static SharedPreferences? _prefs;

  TokenApis._();

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> update(String token) async {
    if (_prefs == null) {
      throw Future.error(
          StateError('instance not initialize. please call TokenApis.init()'));
    }

    return await _prefs!.setString('token', token);
  }

  String read() {
    if (_prefs == null) {
      throw Future.error(
          StateError('instance not initialize. please call TokenApis.init()'));
    }

    return _prefs?.getString('token') ?? '';
  }
}
