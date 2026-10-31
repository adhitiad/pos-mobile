/// Model item transaksi (baris dalam keranjang) sesuai API transaksi.
class ItemTransaksi {
  const ItemTransaksi({
    required this.produkId,
    required this.produkNama,
    required this.harga,
    required this.qty,
    this.modifiers = const [],
    this.catatan,
  });

  final String produkId;
  final String produkNama;
  final int harga;
  final int qty;
  final List<ItemModifier> modifiers;
  final String? catatan;

  int get subtotal =>
      harga * qty +
      modifiers.fold(0, (sum, m) => sum + m.hargaTambahan * m.qty);

  factory ItemTransaksi.fromJson(Map<String, dynamic> json) {
    return ItemTransaksi(
      produkId: json['produkId'] as String,
      produkNama: json['namaProduk'] as String,
      harga: json['harga'] as int,
      qty: json['qty'] as int,
      modifiers: (json['modifiers'] as List? ?? [])
          .map((e) => ItemModifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      catatan: json['catatan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produkId': produkId,
      'qty': qty,
      'modifiers': modifiers.map((m) => m.toJson()).toList(),
      if (catatan != null) 'catatan': catatan,
    };
  }
}

/// Modifier tambahan pada item transaksi.
class ItemModifier {
  const ItemModifier({
    required this.modifierId,
    required this.nama,
    required this.hargaTambahan,
    required this.qty,
    this.catatan,
  });

  final String modifierId;
  final String nama;
  final int hargaTambahan;
  final int qty;
  final String? catatan;

  factory ItemModifier.fromJson(Map<String, dynamic> json) {
    return ItemModifier(
      modifierId: json['modifierId'] as String,
      nama: json['nama'] as String,
      hargaTambahan: json['hargaTambahan'] as int,
      qty: json['qty'] as int,
      catatan: json['catatan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modifierId': modifierId,
      'nama': nama,
      'hargaTambahan': hargaTambahan,
      'qty': qty,
      if (catatan != null) 'catatan': catatan,
    };
  }
}
