# WAJIB: Batas Ukuran File

> File yang terlalu besar sulit diuji, sulit dibaca, dan rentan regression.

## Aturan

- File tulisan tangan (bukan hasil generate) maksimal **397 baris**.
- Maksimal **407 baris** hanya diperbolehkan untuk menahan satu unit utuh yang
  tidak dapat dipecah tanpa merusak kontrak, dengan alasan tertulis dalam pesan
  commit atau PR.
- Saat mendekati batas, pecah file berdasarkan tanggung jawab (mis. layanan API
  dipisah dari model, widget besar dipisah menjadi komponen kecil).
- File hasil generate (`*.g.dart`, `*.freezed.dart`) dikecualikan dari batas ini.

## Pengecekan

Sebelum mengcentang tugas selesai, hitung baris file yang diubah:

```bash
wc -l lib/src/**/*.dart
```

Jika melebihi 397 baris, perbaiki sebelum commit.
