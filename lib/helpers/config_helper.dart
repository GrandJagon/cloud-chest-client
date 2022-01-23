import 'package:cloud_chest/helpers/storage_helper.dart';
import 'dart:convert';

// Singleton class to handle user config to access the server
class Config {
  static Config _singleton = new Config._internal();
  bool isSetup = false;
  Map<String, dynamic> _config = Map<String, dynamic>();

  factory Config() {
    return _singleton;
  }

  Config._internal();

  // Loads config if it exists in local storage
  Future<void> init() async {
    String? configInfo = await SecureStorage().read('cloudchest_config');

    if (configInfo != null) {
      print('config found with ' + configInfo.toString());
      _config['host'] = json.decode(configInfo)['host'];
      _config['port'] = json.decode(configInfo)['port'];
      isSetup = true;
      return;
    }
  }

  // Getter for config values
  String get(String key) => _config[key];

  // Updates the config map
  void update(String key, String value) => _config[key] = value;

  // Saves the user config in the shared preferences
  Future<void> savePreferences() async {
    try {
      await SecureStorage().write('cloudchest_config', json.encode(_config));
    } catch (err) {
      print(err);
    }
  }
}
