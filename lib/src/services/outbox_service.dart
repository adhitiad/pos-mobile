import 'dart:async';
import 'dart:convert';

import 'package:pos_mobile/src/services/api_client.dart';
import 'package:pos_mobile/src/services/offline_db.dart';
import 'package:pos_mobile/src/services/session_storage.dart';

/// Manajemen antrean sinkronisasi offline.
///
/// Item yang gagal dikirim saat offline masuk ke `outbox` SQLite dan akan
/// dicoba ulang saat koneksi pulih. `idempotencyKey` memastikan retry tidak
/// membuat duplikasi transaksi di server.
class OutboxService {
  OutboxService({
    required this.apiClient,
    required this.db,
    required this.sessionStorage,
  });

  final PosApiClient apiClient;
  final OfflineDatabase db;
  final SessionStorage sessionStorage;

  bool _syncing = false;

  /// Kirim satu item outbox ke server. Bila sukses, tandai terkirim dan hapus.
  Future<bool> _kirimSatu(Map<String, dynamic> item) async {
    final id = item['id'] as String;
    final endpoint = item['endpoint'] as String;
    final payload =
        jsonDecode(item['payload'] as String) as Map<String, dynamic>;

    try {
      final res = await apiClient.post(endpoint, body: payload);
      if (res['ok'] == true) {
        await db.tandaiTerkirim(id);
        return true;
      }
      // Domain error (422) tidak boleh dicoba ulang berulang kali.
      final code = (res['error'] as Map?)?['code'] as String?;
      if (code == 'DOMAIN' || code == 'BAD_REQUEST') {
        await db.tandaiGagal(id);
        return false;
      }
      throw Exception('Server error: $res');
    } catch (e) {
      await db.tandaiGagal(id);
      return false;
    }
  }

  /// Sinkronisasi semua outbox pending. Dipanggil saat aplikasi online.
  Future<void> sinkronkan() async {
    if (_syncing) return;
    _syncing = true;
    try {
      final pending = await db.ambilOutboxPending();
      for (final item in pending) {
        await _kirimSatu(item);
      }
      await db.hapusTerkirim();
    } finally {
      _syncing = false;
    }
  }

  /// Tambah item ke outbox dan coba kirim segera bila online.
  Future<void> antrekan({
    required String id,
    required String idempotencyKey,
    required String endpoint,
    required Map<String, dynamic> payload,
    bool cobaSekarang = false,
  }) async {
    await db.tambahOutbox(
      id: id,
      idempotencyKey: idempotencyKey,
      endpoint: endpoint,
      payload: payload,
    );
    if (cobaSekarang) {
      await sinkronkan();
    }
  }

  /// Jumlah item menunggu sinkronisasi.
  Future<int> hitungPending() async {
    final items = await db.ambilOutboxPending();
    return items.length;
  }
}
