import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos_mobile/src/services/session_storage.dart';

/// Implementasi [SessionStorage] dengan `flutter_secure_storage`.
///
/// Token disimpan di keystore native (iOS Keychain / Android Keystore),
/// bukan di shared_preferences atau source code, sesuai aturan keamanan
/// di `E:/code/pos/docs/API.md`.
class FlutterSecureSessionStorage implements SessionStorage {
  FlutterSecureSessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kunciToken = 'pos_session_token';

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _kunciToken, value: token);
  }

  @override
  Future<String?> readToken() async => await _storage.read(key: _kunciToken);

  @override
  Future<void> deleteToken() async => await _storage.delete(key: _kunciToken);
}
