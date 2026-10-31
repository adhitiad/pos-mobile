# WAJIB: Keterbacaan Kode

> Kode harus mudah dibaca oleh manusia dan agen AI, tidak hanya mudah dijalankan
> mesin.

## Aturan

- Nama variabel, fungsi, kelas, dan file menggunakan deskripsi bisnis yang jelas.
  Hindari singkatan yang tidak umum (`x`, `data`, `temp`, `foo`, `bar`).
- Satu file = satu tanggung jawab utama. Pecah file yang menjadi "kotak ajaib"
  berisi banyak hal yang tidak terkait.
- Hindari nesting berlebihan (>3 tingkat). Ekstrak kondisi kompleks ke fungsi
  atau variabel dengan nama yang bermakna.
- Hindari one-liner yang sulit dibaca, ternary bersarang, dan mutation tersembunyi.
- Gunakan const / final untuk variabel yang tidak berubah. Hindari `late`
  kecuali benar-benar diperlukan.
- Setiap layar dan fitur penting harus memiliki komentar yang menjelaskan *mengapa*
  ada, bukan sekadar apa yang dilakukan kode.

## Format

- Ikuti gaya bawaan `flutter_lints` (`flutter analyze`). Jangan menimpa aturan
  lint tanpa alasan yang tertulis di pesan commit.
- Baris maksimal 100 karakter. Gunakan spasi, tidak ada tab (Dart convention).
