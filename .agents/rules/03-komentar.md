# WAJIB: Komentar

> Komentar menjelaskan *mengapa*, bukan sekadar mengulang apa yang terlihat dari
> nama kode. Hapus komentar yang sudah salah atau tidak relevan.

## Aturan

- Setiap file baru yang berisi logika bisnis harus memiliki komentar di bagian
  atas yang menjelaskan tujuan file tersebut.
- Komentar diubah atau dihapus dalam diff yang sama saat perilaku kode berubah,
  jangan biarkan komentar menjadi kebohongan.
- Jangan gunakan docstring template (`///` tanpa isi yang bermakna) pada setiap
  fungsi.
- Referensi ke `E:/code/pos/docs/API.md` atau dokumentasi Flutter disertakan
  bila komentar berkaitan dengan kontrak API atau batasan SDK.
- Komentar berisi aturan bisnis, batasan Flutter/Android, workaround, dan
  alasan keamanan/performa yang tidak terlihat dari nama fungsi.

## Dilarang

- Komentar AI generik seperti "TODO: implementasi", "FIXME nanti", atau
  "diperbaiki nanti" tanpa konteks yang dapat ditindaklanjuti.
- Komentar yang hanya menggulir nama variabel (`// inisialisasi variabel nama`).
