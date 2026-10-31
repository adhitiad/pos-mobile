/// Model member dari `GET /api/v1/member` atau `GET /api/v1/saya`.
class Member {
  const Member({
    required this.id,
    required this.nama,
    this.telepon,
    this.email,
    this.alamat,
    required this.poin,
    required this.totalBelanja,
    required this.tier,
  });

  final String id;
  final String nama;
  final String? telepon;
  final String? email;
  final String? alamat;
  final int poin;
  final int totalBelanja;
  final String tier;

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      nama: json['nama'] as String,
      telepon: json['telepon'] as String?,
      email: json['email'] as String?,
      alamat: json['alamat'] as String?,
      poin: json['poin'] as int? ?? 0,
      totalBelanja: json['totalBelanja'] as int? ?? 0,
      tier: json['tier'] as String? ?? 'REGULER',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'telepon': telepon,
      'email': email,
      'alamat': alamat,
      'poin': poin,
      'totalBelanja': totalBelanja,
      'tier': tier,
    };
  }
}
