import "package:flutter_secure_storage/flutter_secure_storage.dart";

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> write(String key, dynamic value) async {
    await _storage.write(key: key, value: value.toString());
  }

  Future<dynamic> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
