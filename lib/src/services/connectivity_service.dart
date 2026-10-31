import 'package:connectivity_plus/connectivity_plus.dart';

/// Deteksi status koneksi jaringan.
///
/// Digunakan untuk menentukan apakah sinkronisasi outbox boleh dijalankan
/// dan untuk menampilkan indikator offline di UI.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Periksa status koneksi saat ini. Mengembalikan true bila ada jaringan
  /// (WiFi, seluler, Ethernet, dll.).
  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  /// Stream status koneksi yang berubah. Emisi true/false setiap kali
  /// koneksi mulus/putus. Gunakan untuk memicu sinkronisasi otomatis saat
  /// kembali online.
  Stream<bool> get onStatusChanged =>
      _connectivity.onConnectivityChanged.map((results) {
        return results.isNotEmpty && !results.contains(ConnectivityResult.none);
      });
}
