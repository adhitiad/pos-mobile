/// Model data transaksi yang diterima dari backend POS.
///
/// Field sesuai dengan `E:/code/pos/docs/API.md`. Jangan menambahkan field yang
// tidak terdefinisi dalam kontrak API.
class Transaksi {
  final String id;
  final String nomor;
  final int total;
  final String status;

  const Transaksi({
    required this.id,
    required this.nomor,
    required this.total,
    required this.status,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'] as String,
      nomor: json['nomor'] as String,
      total: json['total'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nomor': nomor, 'total': total, 'status': status};
  }
}
