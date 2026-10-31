# WAJIB: API POS & Keamanan Klien

> `E:/code/pos/docs/API.md` adalah satu-satunya kontrak data antara aplikasi
> Flutter dan backend POS.

## Kontrak API

- Baca `E:/code/pos/docs/API.md` sebelum membuat atau mengubah request. Jangan
  menebak endpoint, payload, peran, status HTTP, atau bentuk respons.
- Perubahan kontrak dilakukan di backend `E:/code/pos` terlebih dahulu dan
  didokumentasikan di file tersebut; aplikasi mobile hanya mengonsumsi.
- Pisahkan fungsi request, validasi/parsing respons, dan komponen layar. Jangan
  menyebar URL atau pemetaan respons di banyak layar.
- Simpan base URL non-rahasia di environment; jangan taruh token, kata sandi, atau
  kunci privat pada variabel publik / source code.

## Sesi dan error

- Untuk request yang butuh sesi, kirim `Authorization: Bearer <token>` (token
  dari `/api/v1/auth-native`). Simpan token sesi hanya di
  `flutter_secure_storage`, bukan AsyncStorage / shared_preferences tanpa enkripsi,
  source code, screenshot, atau log.
- Jangan mencetak token, header otorisasi, body kredensial, atau respons mentah
  ke console maupun UI.
- Tampilkan pesan yang aman dan dapat ditindaklanjuti untuk kegagalan jaringan,
  autentikasi, validasi, dan server. Detail teknis cukup di log aman tanpa data
  sensitif.
- Gunakan HTTPS untuk backend non-lokal dan jangan mempercayai total, diskon,
  pajak, harga, atau stok yang dihitung di klien sebagai sumber kebenaran.
- Deteksi koneksi (`connectivity_plus`) dan tangani offline / retry dengan
  graceful; jangan asumsi jaringan selalu stabil.
