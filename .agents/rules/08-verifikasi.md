# WAJIB: Verifikasi Akhir

> Perubahan kode belum selesai tanpa pemeriksaan statis yang hijau.

## Urutan wajib untuk perubahan kode

1. `flutter pub get` (setelah mengubah `pubspec.yaml`)
2. `flutter analyze`
3. `flutter test`
4. Jika layar, navigasi, atau perilaku Android berubah: jalankan `flutter run`
   pada emulator/perangkat Android yang tersedia dan uji alur yang disentuh.

## Ketentuan

- Jika satu langkah gagal, perbaiki lalu jalankan ulang langkah yang relevan.
- Untuk request baru/berubah, cocokkan payload dan respons dengan
  `E:/code/pos/docs/API.md`; uji state sukses, loading, error, dan sesi tidak sah.
- Laporkan perintah yang dijalankan, hasilnya, serta bagian yang tidak dapat
  diuji karena emulator, perangkat, atau akses backend tidak tersedia.
