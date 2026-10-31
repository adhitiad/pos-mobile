/// Klien HTTP untuk backend POS.
///
/// Semua permintaan dikirim ke base URL backend dan menyertakan
/// `Authorization: Bearer <token>` bila sesi tersedia. Detail implementasi
/// disesuaikan dengan `E:/code/pos/docs/API.md`.
abstract class PosApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers});
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });
}
