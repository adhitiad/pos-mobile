import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Root widget aplikasi POS mobile.
///
/// Routing didefinisikan di sini melalui [GoRouter]. Setiap rute memetakan ke
/// layar di `lib/src/screens/`.
class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialRoute: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      ],
    );

    return MaterialApp.router(
      title: 'POS Mobile',
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0F62FE),
      ),
    );
  }
}

/// Layar beranda sementara. Ganti dengan layar kasir aktual sesuai API backend.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('POS Mobile — siap dikembangkan')),
    );
  }
}
