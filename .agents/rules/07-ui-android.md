# WAJIB: UI & Android

> Pola visual dan interaksi untuk perangkat Android di toko.

## Aturan

- Target sentuh minimal 48×48 dp; aksi kritis (Bayar, Simpan, Hapus) mudah
  dicapai jari.
- Hormati safe area, keyboard, dan orientasi kunci; jangan menutupi konten
  kritis (total, tombol bayar).
- Setiap tombol destruktif / tidak dapat dibatalkan butuh konfirmasi; jangan
  mengandalkan warna saja untuk menyampaikan makna.
- Aksesibilitas: label yang bermakna (`Semantics`), kontras cukup, urutan fokus
  logis, dan umpan balik non-warna.
- Indikasi status (loading, error, kosong, retry) selalu terlihat pada layar
  yang memuat data.
- Hindari animasi berat yang memblokir UI thread pada perangkat toko kelas menengah.
