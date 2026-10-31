/// Model kategori produk dari `GET /api/v1/kategori`.
class Kategori {
  const Kategori({
    required this.id,
    required this.nama,
    this.deskripsi,
    required this.aktif,
  });

  final String id;
  final String nama;
  final String? deskripsi;
  final bool aktif;

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'] as String,
      nama: json['nama'] as String,
      deskripsi: json['deskripsi'] as String?,
      aktif: json['aktif'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'deskripsi': deskripsi, 'aktif': aktif};
  }
}
