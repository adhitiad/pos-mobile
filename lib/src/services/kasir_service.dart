import 'package:pos_mobile/src/models/draft_transaksi.dart';
import 'package:pos_mobile/src/models/kasir_data.dart';
import 'package:pos_mobile/src/models/item_transaksi.dart';
import 'package:pos_mobile/src/models/produk.dart';
import 'package:pos_mobile/src/services/api_client.dart';
import 'package:pos_mobile/src/services/offline_db.dart';
import 'package:pos_mobile/src/services/outbox_service.dart';
import 'package:pos_mobile/src/services/session_storage.dart';

/// Layanan kasir: mengambil katalog, membuat draft, dan menangani checkout
/// baik online maupun offline (antrean).
class KasirService {
  KasirService({
    required this.apiClient,
    required this.db,
    required this.outbox,
    required this.sessionStorage,
  });

  final PosApiClient apiClient;
  final OfflineDatabase db;
  final OutboxService outbox;
  final SessionStorage sessionStorage;

  /// Ambil katalog kasir (produk, kategori, member, delivery) dari server.
  /// Jika gagal, fallback ke cache lokal.
  Future<KasirData> ambilKatalog() async {
    try {
      final res = await apiClient.get('/api/v1/kasir-data');
      if (res['ok'] == true) {
        final data = KasirData.fromJson(res['data'] as Map<String, dynamic>);
        await db.simpanProdukCache(data.produk.map((p) => p.toJson()).toList());
        return data;
      }
    } catch (e) {
      // Jaringan mati — pakai cache lokal.
    }
    final cache = await db.ambilProdukCache();
    return KasirData(
      kategori: const [],
      produk: cache
          .map((e) => Produk.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      member: const [],
      delivery: const [],
    );
  }

  /// Buat draft transaksi. Bila online, kirim ke server; bila offline,
  /// simpan lokal dan antrekan ke outbox.
  Future<DraftTransaksi> buatDraft({
    required List<ItemTransaksi> items,
    required String metodeBayar,
    int? uangDiterima,
    String? memberId,
    String? deliveryId,
    int diskon = 0,
    bool dibuatOffline = false,
    String? waktuKlien,
  }) async {
    final subtotal = items.fold(0, (sum, item) => sum + item.subtotal);
    final total = subtotal - diskon;

    final id = 'draft-${DateTime.now().millisecondsSinceEpoch}';
    final nomor =
        'DRAFT-${DateTime.now().toUtc().toIso8601String().substring(0, 16).replaceAll(RegExp(r'[-:T]'), '')}';
    final now = waktuKlien ?? DateTime.now().toUtc().toIso8601String();

    final payload = {
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'total': total,
      'metodeBayar': metodeBayar,
      if (uangDiterima != null) 'uangDiterima': uangDiterima,
      if (memberId != null) 'memberId': memberId,
      if (deliveryId != null) 'deliveryId': deliveryId,
      if (diskon > 0) 'diskon': diskon,
      'dibuatOffline': dibuatOffline,
      'waktuKlien': now,
    };

    // Simpan ke DB lokal terlebih dahulu (sumber kebenaran offline).
    await db.simpanDraftLokal(
      id: id,
      nomor: nomor,
      subtotal: subtotal,
      total: total,
      metodeBayar: metodeBayar,
      uangDiterima: uangDiterima,
      waktuKlien: now,
      items: items.map((e) => e.toJson()).toList(),
    );

    final draft = DraftTransaksi(
      id: id,
      nomor: nomor,
      subtotal: subtotal,
      total: total,
      status: 'DRAFT',
      metodeBayar: metodeBayar,
      dibuatOffline: dibuatOffline,
      createdAt: DateTime.parse(now),
      items: items,
    );

    if (!dibuatOffline) {
      // Kirim ke server dengan idempotensi.
      await outbox.antrekan(
        id: 'outbox-$id',
        idempotencyKey: id,
        endpoint: '/api/v1/transaksi-draft',
        payload: payload,
        cobaSekarang: true,
      );
    }

    return draft;
  }
}
