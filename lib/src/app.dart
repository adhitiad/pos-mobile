import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_mobile/src/screens/kasir_screen.dart';
import 'package:pos_mobile/src/screens/login_screen.dart';
import 'package:pos_mobile/src/services/session_storage_impl.dart';

/// Root widget aplikasi POS mobile.
///
/// Routing didefinisikan di sini melalui [GoRouter]. Setiap rute memetakan ke
/// layar di `lib/src/screens/`.
class PosApp extends StatelessWidget {
  PosApp({super.key}) : _storage = FlutterSecureSessionStorage();

  final FlutterSecureSessionStorage _storage;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',
      redirect: (context, state) async {
        final loggedIn = await _storage.readToken() != null;
        final loginRoute = state.matchedLocation == '/login';
        if (!loggedIn && !loginRoute) return '/login';
        if (loggedIn && loginRoute) return '/kasir';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/kasir',
          builder: (context, state) => const KasirScreen(),
        ),
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
