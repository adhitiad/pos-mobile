import 'dart:async';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Database SQLite lokal untuk antrean offline dan cache katalog.
///
/// Tabel:
/// - `transaksi_lokal`: draft transaksi yang dibuat saat offline, siap
///   dikirim saat koneksi pulih.
/// - `outbox`: item antrean sinkronisasi dengan `idempotencyKey` agar retry
///   tidak membuat duplikat di server.
/// - `produk_cache`: snapshot produk untuk browsing saat offline.
class OfflineDatabase {
  OfflineDatabase._internal(this._db);
  factory OfflineDatabase() => _instance!;
  static OfflineDatabase? _instance;

  final Database _db;

  static Future<OfflineDatabase> buka() async {
    if (_instance != null) return _instance!;
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'pos_mobile.db');
    final db = await openDatabase(dbPath, version: 1, onCreate: _buatTabel);
    _instance = OfflineDatabase._internal(db);
    return _instance!;
  }

  static Future<void> _buatTabel(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transaksi_lokal(
        id TEXT PRIMARY KEY,
        nomor TEXT,
        subtotal INTEGER,
        total INTEGER,
        status TEXT DEFAULT 'DRAFT',
        metode_bayar TEXT,
        uang_diterima INTEGER,
        dibuat_offline INTEGER DEFAULT 1,
        waktu_klien TEXT,
        created_at TEXT DEFAULT (datetime('now'))
      )
    ''');
    await db.execute('''
      CREATE TABLE transaksi_item_lokal(
        id TEXT PRIMARY KEY,
        transaksi_id TEXT NOT NULL,
        produk_id TEXT NOT NULL,
        produk_nama TEXT,
        harga INTEGER,
        qty INTEGER,
        subtotal INTEGER,
        FOREIGN KEY(transaksi_id) REFERENCES transaksi_lokal(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE outbox(
        id TEXT PRIMARY KEY,
        idempotency_key TEXT UNIQUE NOT NULL,
        endpoint TEXT NOT NULL,
        payload TEXT NOT NULL,
        status TEXT DEFAULT 'pending',
        retry_count INTEGER DEFAULT 0,
        created_at TEXT DEFAULT (datetime('now')),
        updated_at TEXT DEFAULT (datetime('now'))
      )
    ''');
    await db.execute('''
      CREATE TABLE produk_cache(
        id TEXT PRIMARY KEY,
        nama TEXT,
        sku TEXT,
        harga INTEGER,
        stok INTEGER,
        kategori_id TEXT,
        aktif INTEGER DEFAULT 1,
        updated_at TEXT DEFAULT (datetime('now'))
      )
    ''');
  }

  /// Simpan draft transaksi lokal beserta items-nya dalam satu transaksi DB.
  Future<void> simpanDraftLokal({
    required String id,
    required String nomor,
    required int subtotal,
    required int total,
    required String metodeBayar,
    int? uangDiterima,
    required String waktuKlien,
    required List<Map<String, dynamic>> items,
  }) async {
    final batch = _db.batch();
    batch.insert('transaksi_lokal', {
      'id': id,
      'nomor': nomor,
      'subtotal': subtotal,
      'total': total,
      'status': 'DRAFT',
      'metode_bayar': metodeBayar,
      'uang_diterima': uangDiterima,
      'dibuat_offline': 1,
      'waktu_klien': waktuKlien,
    });
    for (final item in items) {
      batch.insert('transaksi_item_lokal', {
        'id': item['id'],
        'transaksi_id': id,
        'produk_id': item['produkId'],
        'produk_nama': item['namaProduk'],
        'harga': item['harga'],
        'qty': item['qty'],
        'subtotal': item['subtotal'],
      });
    }
    await batch.commit(noResult: true);
  }

  /// Tambah item ke outbox. `idempotencyKey` unik mencegah duplikasi saat retry.
  Future<void> tambahOutbox({
    required String id,
    required String idempotencyKey,
    required String endpoint,
    required Map<String, dynamic> payload,
  }) async {
    await _db.insert('outbox', {
      'id': id,
      'idempotency_key': idempotencyKey,
      'endpoint': endpoint,
      'payload': jsonEncode(payload),
      'status': 'pending',
      'retry_count': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Ambil semua outbox dengan status pending, diurutkan paling lama dulu.
  Future<List<Map<String, dynamic>>> ambilOutboxPending() async {
    return _db.query(
      'outbox',
      where: "status = 'pending'",
      orderBy: 'created_at ASC',
    );
  }

  /// Tandai outbox item sebagai terkirim.
  Future<void> tandaiTerkirim(String id) async {
    await _db.update(
      'outbox',
      {'status': 'sent', 'updated_at': datetimeNow()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Tandai outbox item sebagai gagal dan tambah retry count.
  Future<void> tandaiGagal(String id) async {
    await _db.rawUpdate(
      '''
      UPDATE outbox
      SET status = 'failed', retry_count = retry_count + 1, updated_at = ?
      WHERE id = ?
    ''',
      [datetimeNow(), id],
    );
  }

  /// Hapus outbox item yang sudah terkirim.
  Future<void> hapusTerkirim() async {
    await _db.delete('outbox', where: "status = 'sent'");
  }

  /// Simpan cache produk (diganti penuh saat sinkronisasi katalog).
  Future<void> simpanProdukCache(List<Map<String, dynamic>> produk) async {
    final batch = _db.batch();
    batch.delete('produk_cache');
    for (final p in produk) {
      batch.insert('produk_cache', {
        'id': p['id'],
        'nama': p['nama'],
        'sku': p['sku'],
        'harga': p['harga'],
        'stok': p['stok'],
        'kategori_id': p['kategoriId'],
        'aktif': (p['aktif'] == true) ? 1 : 0,
      });
    }
    await batch.commit(noResult: true);
  }

  /// Ambil semua produk aktif dari cache lokal.
  Future<List<Map<String, dynamic>>> ambilProdukCache() async {
    return _db.query('produk_cache', where: 'aktif = 1', orderBy: 'nama ASC');
  }

  static String datetimeNow() => DateTime.now().toUtc().toIso8601String();

  Future<void> tutup() async => await _db.close();
}
