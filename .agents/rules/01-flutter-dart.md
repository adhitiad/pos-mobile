# WAJIB: Flutter & Dart

> Berlaku untuk semua perintah di repo ini. Tidak ada pengecualian.

## Aturan

- **WAJIB** memakai `flutter` untuk instalasi dan script proyek.
- **DILARANG** memakai `npm`, `npx`, `yarn`, `pnpm`, atau `bun` untuk menambah
  dependency Flutter; gunakan `flutter pub add <paket>` atau edit `pubspec.yaml`
  lalu `flutter pub get`.
- Tambah atau perbarui dependency lewat `pubspec.yaml`, kemudian
  `flutter pub get`. Jangan meniru contoh `flutter pub add` dari dokumentasi
  pihak ketiga tanpa memeriksa kompatibilitas versi.
- Native module (plugin Flutter) baru membutuhkan `flutter create .` untuk
  meregenerate wrapper `android/` / `ios/`; jangan mengedit `android/` atau
  `ios/` secara manual — konfigurasikan melalui `pubspec.yaml` dan plugin yang
  sesuai.

## Perintah proyek

| Kebutuhan | Perintah |
|---|---|
| Pasang dependency | `flutter pub get` |
| Tambah package | `flutter pub add <paket>` |
| Jalankan dev (Android) | `flutter run` |
| Build APK release | `flutter build apk --release` |
| Analisis statis / lint | `flutter analyze` |
| Tes | `flutter test` |
| Generate native wrapper | `flutter create .` (saat Flutter SDK tersedia) |

Terjemahkan semua contoh `flutter pub add ...` dan `flutter run ...` sesuai
versi stabil yang terpasang.
