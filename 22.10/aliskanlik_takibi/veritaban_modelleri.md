# Firebase Firestore Veritabanı Mimarisi

Uygulamanın verileri NoSQL tabanlı Cloud Firestore'da tutulacaktır. Koleksiyon yapıları aşağıdaki gibi tasarlanmalıdır.

## 1. Koleksiyon: `users`
Kullanıcı profil ve liderlik tablosu verilerini içerir.
- `uid` (String, Document ID)
- `ad_soyad` (String)
- `kullanici_adi` (String - Unique)
- `email` (String)
- `telefon` (String)
- `kayit_tarihi` (Timestamp)
- `toplam_puan` (Number - Leaderboard için ana sıralama kriteri)

## 2. Koleksiyon: `habits`
Kullanıcının oluşturduğu alışkanlıkların tanımını tutar.
- `habit_id` (String, Document ID)
- `uid` (String) -> Sahibi olan kullanıcı.
- `baslik` (String) -> "Kitap Oku", "Sigarayı Bırak" vb.
- `tip` (String) -> `sagliki` veya `zararli`.
- `gunluk_maliyet` (Number) -> Sadece `zararli` tipinde, kullanıcının girdiği tutar (Örn: 60 TL).
- `olusturulma_tarihi` (Timestamp)
- `aktif_streak` (Number) -> Mevcut seri uzunluğu (Örn: 14 gün).
- `en_uzun_streak` (Number) -> Bugüne kadarki en iyi rekor.

## 3. Koleksiyon: `habit_logs` (veya `habits` altında sub-collection)
Günlük işaretlemeleri takip etmek için.
- `log_id` (String)
- `habit_id` (String)
- `tarih` (Timestamp - Gün/Ay/Yıl bazlı)
- `tamamlandi_mi` (Boolean)

## 4. Koleksiyon: `uyari_bilgileri` (Opsiyonel - Sadece Okuma)
Zararlı alışkanlıklar sayfasında gösterilecek rastgele bilgiler için admin tarafından doldurulan tablo.
- `id` (String)
- `icerik` (String) -> "Sigarayı bıraktıktan 48 saat sonra tat ve koku duyularınız normale döner."
- `kategori` (String) -> `sigara`, `alkol`.