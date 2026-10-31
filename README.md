# pos-mobile (Flutter)

Aplikasi klien mobile POS yang dibangun dengan **Flutter** (menggantikan Expo
sebelumnya). Konsumsi REST API backend POS yang berada di `E:/code/pos`.

## Struktur

- `pubspec.yaml` — definisi proyek Flutter + dependency.
- `lib/src/` — kode Dart (main, app, model, service, screen, widget, util).
- `test/` — tes unit/widget Flutter.
- `android/`, `ios/`, `web/`, `windows/` — wrapper native (belum di-generate).
- `.agents/rules/*.md` — aturan wajib agen (mirip repo backend).
- `AGENTS.md` — panduan utama agen untuk repo ini.
- `opencode.json` — konfigurasi MCP server lokal (`pos-mobile`, `pos-backend`).

## Sebelum mem-build

Flutter SDK **belum terpasang** di mesin ini, sehingga wrapper native
(`android/`, `ios/`, `web/`, `windows/`) belum di-generate. Jalankan setelah
Flutter SDK tersedia:

```bash
flutter create .
flutter pub get
flutter analyze
flutter test
flutter run
```

## Aturan

Semua perubahan di repo ini harus melalui `AGENTS.md` dan
`.agents/rules/*.md`. Kontrak API dibaca dari `E:/code/pos/docs/API.md`
(melalui MCP `pos-backend`).

## Perintah wajib (urutan verifikasi)

1. `flutter pub get`
2. `flutter analyze`
3. `flutter test`
4. `flutter run` (emulator/perangkat Android)

## Catatan

Direktori lama `E:\code\pos_mobile` (Expo) masih ada di mesin ini. Repo ini
(`E:\code\pos-mobile`) adalah penggantinya berbasis Flutter. Jika ingin
menghapus `pos_mobile`, lakukan setelah kode Flutter dikonfirmasi berjalan.
