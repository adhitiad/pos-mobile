import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_mobile/src/services/api_client.dart';
import 'package:pos_mobile/src/services/session_storage_impl.dart';

/// Layar login: tukarkan Google ID token (dari native sign-in) menjadi sesi
/// POS via `POST /api/v1/auth-native`, lalu simpan token di secure storage.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _apiClient = PosApiClient(
    baseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:3000',
    ),
    sessionStorage: FlutterSecureSessionStorage(),
  );
  bool _memuat = false;
  String? _pesanError;

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  Future<void> _masuk() async {
    setState(() {
      _memuat = true;
      _pesanError = null;
    });
    try {
      // Di pengembangan, token diuji lewat input teks. Produksi akan
      // memanggil Google native sign-in terlebih dahulu.
      final tokenController = TextEditingController();
      final result = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Masukkan token sesi (dev)'),
          content: TextField(
            controller: tokenController,
            autofocus: true,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Bearer token dari /api/v1/auth-native',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, tokenController.text),
              child: const Text('Masuk'),
            ),
          ],
        ),
      );
      if (result == null || result.isEmpty) return;

      await (FlutterSecureSessionStorage().saveToken(result));
      if (mounted) context.go('/kasir');
    } catch (e) {
      setState(() => _pesanError = 'Gagal masuk: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _memuat = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.point_of_sale, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'POS Mobile',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Kasir toko — login untuk melanjutkan'),
              const SizedBox(height: 32),
              if (_pesanError != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.red.shade50,
                  child: Text(
                    _pesanError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56, // Target sentuh minimal 48 dp
                child: ElevatedButton.icon(
                  onPressed: _memuat ? null : _masuk,
                  icon: const Icon(Icons.login, size: 24),
                  label: const Text('Masuk', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: _memuat ? null : _masuk,
                  child: const Text('Masuk tanpa token (mode uji coba)'),
                ),
              ),
              if (_memuat) const SizedBox(height: 24),
              if (_memuat) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
