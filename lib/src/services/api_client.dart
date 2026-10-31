import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pos_mobile/src/services/session_storage.dart';

/// Klien HTTP untuk backend POS.
///
/// Semua permintaan dikirim ke [baseUrl] dan menyertakan
/// `Authorization: Bearer <token>` bila sesi tersedia. Respons diharapkan
/// dalam envelope `{ ok: true, data: ... }` atau `{ ok: false, error: ... }`
/// sesuai `E:/code/pos/docs/API.md`.
class PosApiClient {
  PosApiClient({
    required this.baseUrl,
    required this.sessionStorage,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final SessionStorage sessionStorage;
  final http.Client _client;

  String _baseUri(String u) {
    if (u.endsWith('/')) u = u.substring(0, u.length - 1);
    return u;
  }

  /// Header untuk request. Token dibaca dari penyimpanan aman tiap request.
  Future<Map<String, String>> _headers({
    bool auth = true,
    Map<String, String>? tambahan,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (tambahan != null) headers.addAll(tambahan);
    if (auth) {
      final token = await sessionStorage.readToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    // Klien non-browser (Flutter) tidak mengirim Origin, jadi OW-14 (Origin
    // check pada mutasi) tidak berlaku. Token bearer dipakai sebagai identitas.
    return headers;
  }

  /// GET ke [path], kembalikan body JSON decode.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('${_baseUri(baseUrl)}$path');
    final h = await _headers(auth: true, tambahan: headers);
    final res = await _client.get(uri, headers: h);
    return _decode(res);
  }

  /// POST ke [path] dengan [body] JSON.
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('${_baseUri(baseUrl)}$path');
    final h = await _headers(auth: true, tambahan: headers);
    final res = await _client.post(
      uri,
      headers: h,
      body: body != null ? jsonEncode(body) : null,
    );
    return _decode(res);
  }

  /// Decode respons HTTP ke map. Non-2xx dianggap gagal dengan pesan aman.
  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body;
    }
    // Jangan mencetak body respons mentah (mungkin berisi data sensitif).
    debugPrint('PosApiClient error: status=${response.statusCode}');
    return {
      'ok': false,
      'error': {
        'code': 'HTTP_${response.statusCode}',
        'message': 'Permintaan gagal (status ${response.statusCode})',
      },
    };
  }

  void dispose() {
    _client.close();
  }
}
