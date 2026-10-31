# POS Mobile (Flutter)

Klien mobile untuk backend POS di `E:/code/pos`. Dibangun dengan **Flutter** (bukan
Expo lagi). Konsumsi REST API backend melalui `/api/v1*`, menyimpan token sesi di
`flutter_secure_storage`, dan menyesuaikan diri dengan kondisi jaringan toko
(koneksi tidak stabil, layar sentuh kecil, navigasi Back yang dapat diprediksi).

## Struktur direktori

| Direktori                              | Isi                                           |
| -------------------------------------- | --------------------------------------------- |
| `lib/src/main.dart`                    | Titik masuk aplikasi.                         |
| `lib/src/app.dart`                     | Root widget + routing (GoRouter).             |
| `lib/src/models/`                      | Model data (DTO) respons API.                 |
| `lib/src/services/`                    | Klien API, penyimpanan aman, deteksi koneksi. |
| `lib/src/screens/`                     | Layar aplikasi.                               |
| `lib/src/widgets/`                     | Widget yang dibagikan.                        |
| `lib/src/utils/`                       | Utilitas umum.                                |
| `test/`                                | Tes unit dan widget.                          |
| `android/`, `ios/`, `web/`, `windows/` | Wrapper native (hasil `flutter create`).      |

> `android/` dan `ios/` sudah tersedia (hasil `flutter create`). Untuk rebuild
> wrapper native, jalankan `flutter create .`.

## Perintah — Flutter / Dart saja

Jangan `npm`, `npx`, `yarn`, `pnpm`, atau `bun` untuk dependency Flutter.

| Kebutuhan                       | Perintah                      |
| ------------------------------- | ----------------------------- |
| Pasang dependency               | `flutter pub get`             |
| Jalankan dev (Android emulator) | `flutter run`                 |
| Build APK release               | `flutter build apk --release` |
| Typecheck / analisis statis     | `flutter analyze`             |
| Tes                             | `flutter test`                |
| Lint (melalui flutter_lints)    | `flutter analyze`             |

## Urutan verifikasi wajib

1. `flutter pub get` (setelah mengubah `pubspec.yaml`)
2. `flutter analyze`
3. `flutter test`
4. Jika layar / navigasi / perilaku Android berubah: jalankan di emulator atau
   perangkat Android yang tersedia.

Setiap langkah yang gagal harus diperbaiki dan diulang sebelum perubahan
disebut selesai.

## Kontrak API & backend

- Satu-satunya kontrak: `E:/code/pos/docs/API.md`. Baca sebelum membuat atau
  mengubah request; jangan menebak endpoint, payload, peran, status HTTP, atau
  bentuk respons.
- Perubahan kontrak dilakukan di backend `E:/code/pos` terlebih dahulu dan
  didokumentasikan di `docs/API.md`; aplikasi mobile hanya mengonsumsi.
- Base URL non-rahasia di environment (bukan di source code). Jangan taruh token,
  kata sandi, atau kunci privat dalam variabel publik.
- Untuk request yang butuh sesi, kirim `Authorization: Bearer <token>` (token
  dari `/api/v1/auth-native`). Simpan token sesi hanya di
  `flutter_secure_storage`, bukan dalam source code atau log.
- Jangan mencetak token, header otorisasi, atau kredensial ke console maupun UI.
- Total, diskon, pajak, harga, dan stok yang dihitung di klien **bukan** sumber
  kebenaran; selalu sanksi dari server.

## Konvensi kode

- Tipe: eksplik `class` / `typedef`; `dynamic` dan `as dynamic` dilarang. Gunakan
  `null safety` penuh.
- Penamaan domain: istilah bisnis Indonesia (`hitungTotalPesanan`,
  `statusSinkronisasi`); teknis dalam Bahasa Indonesia/English sesuai tim. Satu
  fungsi = satu tanggung jawab; pecah nesting >3 atau >1 alasan perubahan.
- Ukuran file tulisan tangan `< 397` baris; `<= 407` hanya untuk satu utas utuh
  dengan alasan di PR/pesan commit.
- Komentar menjelaskan _mengapa_ (aturan bisnis, batasan Flutter/Android,
  workaround, keamanan/performa yang tidak terlihat dari nama). Perbarui atau
  hapus komentar yang salah dalam diff yang sama. Tidak ada docstring template.

## Referensi

- Kontrak backend: `E:/code/pos/docs/API.md` (via MCP `pos-backend`).
- Aturan detail: `.agents/rules/*.md` di repo ini.
- Flutter: `https://docs.flutter.dev/` dan `https://api.flutter.dev/`.
