/// Model produk yang diterima dari `GET /api/v1/kasir-data` atau
/// `GET /api/v1/produk`. Field sesuai `E:/code/pos/docs/API.md`.
class Produk {
  const Produk({
    required this.id,
    required this.nama,
    this.sku,
    required this.harga,
    required this.stok,
    this.kategoriId,
    required this.aktif,
  });

  final String id;
  final String nama;
  final String? sku;
  final int harga;
  final int stok;
  final String? kategoriId;
  final bool aktif;

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] as String,
      nama: json['nama'] as String,
      sku: json['sku'] as String?,
      harga: json['harga'] as int,
      stok: json['stok'] as int,
      kategoriId: json['kategoriId'] as String?,
      aktif: json['aktif'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'sku': sku,
      'harga': harga,
      'stok': stok,
      'kategoriId': kategoriId,
      'aktif': aktif,
    };
  }

  /// Format harga sebagai rupiah untuk ditampilkan di UI.
  String formatRupiah() {
    return 'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
