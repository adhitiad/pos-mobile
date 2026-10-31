/// Manajemen token sesi di penyimpanan aman perangkat.
///
/// Token disimpan lewat `flutter_secure_storage` (enkripsi native Android /
/// iOS), bukan disimpan dalam source code atau preferensi biasa.
abstract class SessionStorage {
  Future<void> saveToken(String token);
  Future<String?> readToken();
  Future<void> deleteToken();
}
