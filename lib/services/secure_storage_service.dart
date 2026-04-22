import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _usernameKey = 'username';
  static const _emailKey = 'email';

  static Future<void> saveLoginData({
    required String token,
    required String username,
    required String email,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _emailKey, value: email);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  static Future<String?> getUsername() async {
    return _storage.read(key: _usernameKey);
  }

  static Future<String?> getEmail() async {
    return _storage.read(key: _emailKey);
  }

  static Future<void> clearLoginData() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _usernameKey);
    await _storage.delete(key: _emailKey);
  }
}