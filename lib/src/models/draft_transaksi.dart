// Draft transaksi yang belum disetujui (antrean kasir).
import 'package:pos_mobile/src/models/item_transaksi.dart';

class DraftTransaksi {
  const DraftTransaksi({
    required this.id,
    required this.nomor,
    required this.subtotal,
    required this.total,
    required this.status,
    required this.metodeBayar,
    required this.dibuatOffline,
    required this.createdAt,
    this.items = const [],
  });

  final String id;
  final String nomor;
  final int subtotal;
  final int total;
  final String status;
  final String metodeBayar;
  final bool dibuatOffline;
  final DateTime createdAt;
  final List<ItemTransaksi> items;

  factory DraftTransaksi.fromJson(Map<String, dynamic> json) {
    return DraftTransaksi(
      id: json['id'] as String,
      nomor: json['nomor'] as String,
      subtotal: json['subtotal'] as int,
      total: json['total'] as int,
      status: json['status'] as String,
      metodeBayar: json['metodeBayar'] as String,
      dibuatOffline: json['dibuatOffline'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List? ?? [])
          .map((e) => ItemTransaksi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
