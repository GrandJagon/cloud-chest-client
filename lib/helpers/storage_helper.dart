import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Singleton handling any writing/reading to the secure storage system
class SecureStorage {
  static SecureStorage _singleton = new SecureStorage._internal();
  FlutterSecureStorage _storage = new FlutterSecureStorage();

  factory SecureStorage() {
    return _singleton;
  }

  SecureStorage._internal();

  Future<void> write(String key, String value) async {
    return _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  Future<void> clear() async {
    return _storage.deleteAll();
  }
}
