import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;
  static final SharedPrefs _instance = SharedPrefs._internal();
  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get networkConfig => _sharedPrefs.getString(keyNetworkConfig) ?? '';

  set networkConfig(String value) {
    _sharedPrefs.setString(keyNetworkConfig, value);
  }
}

const String keyNetworkConfig = 'network_config';