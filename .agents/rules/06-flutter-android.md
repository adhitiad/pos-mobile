# WAJIB: Flutter & Android

> Aplikasi ini Flutter, berfokus pada Android, dan dipakai di perangkat toko
> (layar sentuh, layar kecil, koneksi tidak stabil).

## Struktur dan navigasi

- Routing menggunakan GoRouter (`lib/src/app.dart`). Layar berada di
  `lib/src/screens/`; komponen dan widget di `lib/src/widgets/`.
- Utamakan pola Android dan perangkat toko: target sentuh besar, aksi kritis
  selalu terlihat, status selalu terlihat, serta navigasi Back yang dapat
  diprediksi.
- Virtualized list (`ListView.builder`) untuk data panjang; hindari pekerjaan
  berat di UI thread, gambar tanpa ukuran, dan re-render berlebihan.
- Setiap layar data butuh state loading / kosong / error / retry.

## Native dan dependency

- Sebelum menyentuh plugin Flutter, baca versi di `pubspec.yaml`, lalu lihat
  dokumentasi resmi plugin (`pub.dev`) dan Flutter (`docs.flutter.dev`); jangan
  mengandalkan ingatan API.
- Pasang package dengan `flutter pub add <paket>` dan pilih plugin resmi Flutter
  sebelum library pihak ketiga.
- Jangan membuat atau mengedit `android/` / `ios/` manual. Atur identitas, ikon,
  permission, dan konfigurasi native melalui `pubspec.yaml` dan konfigurasi
  plugin. Setelah `flutter create .`, wrapper native dihasilkan ulang.
- Setelah menambah plugin native, gunakan development build Android
  (`flutter run` pada emulator/perangkat); pastikan plugin dimuat sebelum rilis.

## Build

- Build release: `flutter build apk --release`. Jangan menyiapkan APK debug untuk
  distribusi toko.
