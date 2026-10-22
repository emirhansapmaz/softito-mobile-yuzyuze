# Kimlik Doğrulama (Auth) Sayfaları Detayları

Bu modülde kullanıcıların kayıt, giriş ve şifre yenileme işlemleri yönetilecektir. Firebase Authentication kullanılacaktır.

## 1. Giriş Yap (Login) Sayfası
- **Görsel Tasarım:** Uygulamanın logosu veya motivasyonel bir görsel (Lottie animasyonu olabilir) üstte yer alır.
- **Girdi Alanları:**
  - `E-posta` (Email format doğrulaması yapılmalı).
  - `Şifre` (Gizle/Göster ikonlu).
- **Aksiyonlar:**
  - `Giriş Yap` butonu: Doğrulama başarılıysa Ana Ekran'a yönlendirir.
  - `Şifremi Unuttum` Text Butonu: Şifre sıfırlama sayfasına yönlendirir.
  - `Hesabın yok mu? Kayıt Ol` Text Butonu: Kayıt sayfasına yönlendirir.

## 2. Yeni Kayıt Ol (Sign Up) Sayfası
- **Girdi Alanları:**
  - `Ad Soyad`: Text input.
  - `Kullanıcı Adı`: Liderlik tablosunda görüneceği için benzersiz (unique) olmalı. (Firestore'dan anlık kontrol yapılabilir).
  - `E-posta`: Geçerli bir e-posta adresi.
  - `Telefon Numarası`: (Opsiyonel veya maskeli format).
  - `Şifre`: Minimum 6 karakter, güvenlik göstergeli.
  - `Şifre Tekrar`: İlk şifre ile eşleşme kontrolü yapılmalı.
- **Aksiyonlar:**
  - `Kayıt Ol` Butonu: Firebase Auth'da hesap oluşturur, başarılı olursa kullanıcı bilgilerini Firestore'daki `users` koleksiyonuna yazar.

## 3. Şifremi Unuttum (Forgot Password) Sayfası
- **Amacı:** Kullanıcının e-posta veya telefon ile şifresini sıfırlaması.
- **Akış:**
  1. Kullanıcı e-posta adresini girer.
  2. "Şifre Sıfırlama Bağlantısı Gönder" butonuna tıklar.
  3. Firebase üzerinden şifre sıfırlama maili tetiklenir.
  4. (Alternatif telefon akışı varsa) SMS doğrulama sonrası `Yeni Şifre` ve `Yeni Şifre (Tekrar)` ekranı açılarak güncelleme sağlanır.