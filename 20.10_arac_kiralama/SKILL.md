# Teknik Beceri Seti ve Yapay Zeka IDE Talimatları

## 1. Çalışma Ortamı
* **Framework:** Flutter
* **Dil:** Dart
* **Platform:** Mobil (iOS ve Android)

## 2. Mimari ve Kurallar (Yapay Zeka İçin KESİN TALİMATLAR)
* **Backend Yok / HTTP Yok:** `http`, `dio` veya herhangi bir dış API paketi KULLANMAYIN.
* **Sadece Mock (Sahte) Veri:** Kullanıcılar, Araçlar ve Rezervasyonlar için sağlam mock veri sınıfları oluşturun.
* **State Management (Durum Yönetimi):** Mock verileri global olarak yönetmek için modern bir durum yönetimi çözümü (ör. Provider veya Riverpod) kullanın. Böylece bir Admin araç eklediğinde veya Müşteri rezervasyon yaptığında, değişiklikler uygulamada dinamik olarak yansıtılsın.
* **Gecikme Simülasyonu:** Gerçekçi yükleme (loading) animasyonları göstermek için giriş, kayıt ve ödeme işlemleri sırasında ağ isteklerini simüle etmek amacıyla `Future.delayed` (ör. 1-2 saniye) kullanın.

## 3. Ödeve Özel UI/UX Gereksinimleri
Bu bir akademik/ödev projesi olduğundan, aşağıdaki Flutter konseptleri belirgin bir şekilde öne çıkarılmalı, iyi yapılandırılmalı ve kod tabanı boyunca yoğun bir şekilde kullanılmalıdır:

* **Material Design 3 ve Tema Yönetimi (Dark/Light):**
  * Material Design 3'ü tam olarak uygulayın (`useMaterial3: true`).
  * Hem Açık (Light) hem de Koyu (Dark) modları destekleyen eksiksiz bir Tema kurulumu sağlayın. Renkler, tipografi ve widget temaları sorunsuz bir şekilde uyum sağlamalıdır.

* **Temel UI Elemanları, Butonlar ve Etkileşimler:**
  * Yeniden kullanılabilir, özel UI bileşenleri oluşturun (ör. `CustomElevatedButton`, `CustomOutlinedButton`).
  * Etkileşimli öğelerin uygun görsel geri bildirimlere (Ripple efektleri, `InkWell`, hover/focus durumları) sahip olduğundan emin olun.

* **Form Yönetimi, Validasyonlar ve Kullanıcı Girişi:**
  * `Form` widget'ını ve `GlobalKey<FormState>` yapısını yoğun olarak kullanın.
  * Kapsamlı validatörler uygulayın (ör. TC Kimlik Numarası için Regex, güçlü şifre kontrolleri, zorunlu alan doğrulama).
  * Net hata durumları ve yardımcı metinler içeren özel `TextFormField` widget'ları ekleyin.

* **Diyaloglar, Pop-up'lar ve Modallar:**
  * Kullanıcı etkileşimleri için diyalogları kapsamlı bir şekilde kullanın.
  * Onay işlemleri için `AlertDialog` uygulayın (ör. Admin'in araç silmesi, kullanıcının ödemeyi onaylaması).
  * **Yakıt Fiyatları Pop-up'ı** ve **Kullanıcı Sözleşmesi** için Özel Diyaloglar/Modallar kullanın.
  * Hedef şehir seçimi veya sıralama/filtreleme seçenekleri için `showModalBottomSheet` kullanın.