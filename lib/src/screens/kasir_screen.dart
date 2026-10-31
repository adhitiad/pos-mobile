import 'package:flutter/material.dart';
import 'package:pos_mobile/src/models/item_transaksi.dart';
import 'package:pos_mobile/src/models/produk.dart';
import 'package:pos_mobile/src/services/kasir_service.dart';
import 'package:pos_mobile/src/services/api_client.dart';
import 'package:pos_mobile/src/services/session_storage_impl.dart';
import 'package:pos_mobile/src/services/offline_db.dart';
import 'package:pos_mobile/src/services/outbox_service.dart';

/// Layar kasir: katalog produk, keranjang, dan tombol bayar.
///
/// Mengikuti aturan UI Android: target sentuh ≥48 dp, status selalu terlihat,
/// daftar produk pakai ListView.builder (virtualized), dan state loading/
/// empty/error/retry terlihat jelas.
class KasirScreen extends StatefulWidget {
  const KasirScreen({super.key});

  @override
  State<KasirScreen> createState() => _KasirScreenState();
}

class _KasirScreenState extends State<KasirScreen> {
  late final PosApiClient _api;
  late final FlutterSecureSessionStorage _storage;
  late final KasirService _kasir;

  bool _memuat = true;
  bool _gagal = false;
  String? _pesanError;
  List<Produk> _produk = [];
  final List<ItemTransaksi> _keranjang = [];
  String _cari = '';

  @override
  void initState() {
    super.initState();
    _api = PosApiClient(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://10.0.2.2:3000',
      ),
      sessionStorage: FlutterSecureSessionStorage(),
    );
    _storage = FlutterSecureSessionStorage();
    _kasir = KasirService(
      apiClient: _api,
      db: OfflineDatabase(),
      outbox: OutboxService(
        apiClient: _api,
        db: OfflineDatabase(),
        sessionStorage: _storage,
      ),
      sessionStorage: _storage,
    );
    _muatKatalog();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _muatKatalog() async {
    setState(() {
      _memuat = true;
      _gagal = false;
      _pesanError = null;
    });
    try {
      final data = await _kasir.ambilKatalog();
      if (mounted) {
        setState(() {
          _produk = data.produk;
          _memuat = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _gagal = true;
          _memuat = false;
          _pesanError = e.toString();
        });
      }
    }
  }

  void _tambahKeKeranjang(Produk produk) {
    setState(() {
      final idx = _keranjang.indexWhere((i) => i.produkId == produk.id);
      if (idx != -1) {
        _keranjang[idx] = ItemTransaksi(
          produkId: produk.id,
          produkNama: produk.nama,
          harga: produk.harga,
          qty: _keranjang[idx].qty + 1,
          modifiers: _keranjang[idx].modifiers,
          catatan: _keranjang[idx].catatan,
        );
      } else {
        _keranjang.add(
          ItemTransaksi(
            produkId: produk.id,
            produkNama: produk.nama,
            harga: produk.harga,
            qty: 1,
          ),
        );
      }
    });
  }

  void _hapusDariKeranjang(int index) {
    setState(() {
      _keranjang.removeAt(index);
    });
  }

  int get _totalKeranjang => _keranjang.fold(0, (sum, i) => sum + i.subtotal);

  Future<void> _bayar() async {
    if (_keranjang.isEmpty) return;
    // TODO: integrasi dengan pembayaran dan antrean draft.
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkout belum diimplementasi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _muatKatalog,
            tooltip: 'Muat ulang katalog',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Pencarian produk
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (nilai) {
                  setState(() {
                    _cari = nilai;
                  });
                },
              ),
            ),
            // Daftur produk (virtualized)
            Expanded(
              child: _memuat
                  ? const Center(child: CircularProgressIndicator())
                  : _gagal
                  ? _blokError()
                  : _produkTidakDitemukan
                  ? const Center(child: Text('Produk tidak ditemukan'))
                  : ListView.builder(
                      itemCount: _produk.length,
                      itemBuilder: (ctx, i) {
                        final p = _produk[i];
                        final cocok =
                            _cari.isEmpty ||
                            p.nama.toLowerCase().contains(_cari.toLowerCase());
                        if (!cocok) return const SizedBox.shrink();
                        return ListTile(
                          leading: const Icon(Icons.restaurant_menu),
                          title: Text(p.nama),
                          subtitle: Text(p.formatRupiah()),
                          trailing: SizedBox(
                            height: 48, // Target sentuh
                            width: 48,
                            child: ElevatedButton(
                              onPressed: () => _tambahKeKeranjang(p),
                              child: const Icon(Icons.add, size: 20),
                            ),
                          ),
                          onTap: () => _tambahKeKeranjang(p),
                        );
                      },
                    ),
            ),
            // Keranjang + total (selalu terlihat)
            _KeranjangRingkas(
              items: _keranjang,
              total: _totalKeranjang,
              onHapus: _hapusDariKeranjang,
            ),
            // Tombol Bayar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _keranjang.isEmpty || _memuat ? null : _bayar,
                child: const Text('Bayar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _produkTidakDitemukan =>
      _cari.isNotEmpty &&
      _produk
          .where((p) => p.nama.toLowerCase().contains(_cari.toLowerCase()))
          .isEmpty;

  Widget _blokError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text('Gagal memuat katalog: $_pesanError'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _muatKatalog,
            child: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }
}

/// Ringkas keranjang yang selalu terlihat di bagian bawah layar.
class _KeranjangRingkas extends StatelessWidget {
  const _KeranjangRingkas({
    required this.items,
    required this.total,
    required this.onHapus,
  });

  final List<ItemTransaksi> items;
  final int total;
  final void Function(int index) onHapus;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        height: 64,
        color: Colors.grey.shade100,
        child: const Center(
          child: Text('Keranjang kosong — tambah produk di atas'),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              return ListTile(
                dense: true,
                title: Text('${item.qty}x ${item.produkNama}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${item.subtotal.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => m[1]! + '.')}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => onHapus(i),
                      tooltip: 'Hapus item',
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 16)),
              Text(
                'Rp ${total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
