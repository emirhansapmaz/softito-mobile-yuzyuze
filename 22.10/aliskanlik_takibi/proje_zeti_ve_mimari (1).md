# Alışkanlık Takibi - Proje Genel Yapısı ve Mimari

## 1. Proje Özeti
Bu proje, kullanıcıların pozitif alışkanlıklar kazanmasını ve zararlı alışkanlıkları (sigara, alkol vb.) bırakmasını oyunlaştırma teknikleriyle (rozetler, liderlik tablosu) destekleyen bir Flutter uygulamasıdır. Projede backend olarak sadece Firebase (Auth & Firestore) kullanılacaktır.

## 2. Tasarım Dili ve UI/UX Kuralları (ÖNEMLİ)
- **Renk Paleti:** Kesinlikle göz yoran, aşırı parlak "neon" veya yapay zeka (AI) üretimi gibi duran karmaşık renklerden **kaçınılmalıdır**. 
- **Konsept:** Modern, minimalist ve "insancıl" bir tasarım hedeflenmektedir. Doğayı ve huzuru çağrıştıran soft/pastel tonlar (yumuşak yeşiller, sakin maviler, toprak tonları ve temiz beyaz/gri arka planlar) kullanılmalıdır.
- **Tipografi ve Formlar:** Köşeleri hafif yuvarlatılmış kartlar (rounded corners), okunabilir temiz sans-serif fontlar ve ferah bir boşluk (whitespace) kullanımı tercih edilmelidir.

## 3. Kullanılacak Teknolojiler
- **UI/Framework:** Flutter (Dart)
- **Backend/BaaS:** Firebase
  - *Firebase Authentication:* E-posta ve şifre ile giriş/kayıt işlemleri.
  - *Cloud Firestore:* Kullanıcı verileri, alışkanlıklar, streak kayıtları ve skor tablosu verileri.
- **State Management:** Riverpod veya Provider (Geliştirici tercihine bırakılmıştır).
- **Mimari:** MVVM veya Clean Architecture standartlarına uygun klasör yapısı (Örn: `lib/screens`, `lib/models`, `lib/services`, `lib/widgets`).

## 4. Geliştirme Aşamaları
- **Faz 1:** Firebase kurulumu, Auth (Giriş/Kayıt) sayfalarının tamamlanması ve ana tasarım temasının (ThemeData) soft renklerle kurulması.
- **Faz 2:** Ana Ekran (Dashboard) ve Alışkanlık Ekleme (Sağlıklı/Zararlı) modüllerinin UI ve Firestore entegrasyonu.
- **Faz 3:** Tasarruf hesaplama algoritması, Puanlama sistemi, Liderlik Tablosu ve Rozetler.
- **Faz 4:** Profil ayarları, şifre sıfırlama, UI cilalama (Animasyonlar, pop-up'lar) ve testler.