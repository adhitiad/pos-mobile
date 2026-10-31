import 'package:pos_mobile/src/models/kategori.dart';
import 'package:pos_mobile/src/models/member.dart';
import 'package:pos_mobile/src/models/produk.dart';

/// Data ringkas kasir dari `GET /api/v1/kasir-data`.
/// Berisi katalog master yang dibutuhkan layar kasir.
class KasirData {
  const KasirData({
    required this.kategori,
    required this.produk,
    required this.member,
    required this.delivery,
  });

  final List<Kategori> kategori;
  final List<Produk> produk;
  final List<Member> member;
  final List<Delivery> delivery;

  factory KasirData.fromJson(Map<String, dynamic> json) {
    return KasirData(
      kategori: (json['kategori'] as List? ?? [])
          .map((e) => Kategori.fromJson(e as Map<String, dynamic>))
          .toList(),
      produk: (json['produk'] as List? ?? [])
          .map((e) => Produk.fromJson(e as Map<String, dynamic>))
          .toList(),
      member: (json['member'] as List? ?? [])
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      delivery: (json['delivery'] as List? ?? [])
          .map((e) => Delivery.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Layanan antar (delivery) dari master, ongkir diambil dari server.
class Delivery {
  const Delivery({
    required this.id,
    required this.nama,
    required this.ongkir,
    required this.aktif,
  });

  final String id;
  final String nama;
  final int ongkir;
  final bool aktif;

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] as String,
      nama: json['nama'] as String,
      ongkir: json['ongkir'] as int? ?? 0,
      aktif: json['aktif'] as bool? ?? false,
    );
  }
}
