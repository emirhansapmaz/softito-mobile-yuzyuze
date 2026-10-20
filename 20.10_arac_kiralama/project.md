# Proje: SEM Auto - Araç Kiralama Uygulaması (Flutter)

## 1. Proje Genel Bakış ve Marka Kimliği
*   **Uygulama Adı:** SEM Auto
*   **Logo Tasarımı:** Tipografik bir logo kullanılacaktır. "SEM" kelimesi Mavi renkte, "Auto" kelimesi Siyah renkte yan yana yazılacaktır (Flutter'da `RichText` veya `Text.rich` kullanılarak kodlanmalıdır).
*   **Uygulama Yapısı:** Flutter ile geliştirilmiş kapsamlı, backend kullanılmayan (Mock Data ve State Management ile çalışan) bir araç kiralama mobil uygulaması. Müşteri ve Admin olmak üzere iki ana rol içerir.

## 2. Temel Özellikler ve İş Mantığı
*   **Araç Kategorileri:** Basic, Basic+, flex, flex+, Lux, Ultra Lux.
*   **Kilometre ve Fiyatlandırma Mantığı:** Günlük sürüş sınırı 250 km'dir. Şehir dışına çıkışlarda mesafe hesaplanır ve aşılan her 250 km için ekstra bir gün ücreti eklenir.
*   **Yakıt Sistemi:** Araç detaylarında tahmini menzili gösteren görsel bir yakıt göstergesi. Tıklandığında 3 farklı şirketin mock yakıt fiyatlarını (Benzin, Dizel, LPG) gösteren bir açılır pencere.

## 3. Kullanıcı Akışları ve Ekranlar

### 3.1. Açılış ve Kimlik Doğrulama
*   **Yükleme Ekranı (Splash Screen):** Uygulama açıldığında ekranda ortalanmış şekilde "SEM Auto" logosu (Mavi SEM, Siyah Auto) görünecektir. Alt kısımda dairesel bir yükleme animasyonu (CircularProgressIndicator) yer alacak ve 2-3 saniyelik bir gecikme simülasyonundan sonra Login ekranına geçiş yapılacaktır.
*   **Giriş (Login):** Müşteri ve Admin girişini destekler.
*   **Kayıt Ol (Register):** Ad, Soyad, TC Kimlik No ve Ehliyet bilgileri.
*   **NFC Simülasyonu:** "Ehliyetini NFC ile Okut" adında göstermelik buton.
*   **Kullanıcı Sözleşmesi:** Tıklandığında metin içeren bir pop-up açan onay kutusu.

### 3.2. Müşteri Akışı
*   **Ana Sayfa:** Araç kategorilerini gösterir.
*   **Araç Listesi Ekranı:** Fiyat, Yıl ve KM'ye göre sıralama ve filtreleme özellikleri.
*   **Araç Detay Ekranı:** Araç resmi, km, yıl, müsaitlik takvimi, yakıt göstergesi ve "Rezervasyon Yap" butonu.
*   **Rezervasyon Ekranı:** Hedef şehir seçimi, 250 km kuralı uyarısı ve mesafe hesaplaması.
*   **Ödeme (Checkout):** Klasik kredi kartı mock ödeme ekranı.

### 3.3. Admin Akışı
*   **Araç Yönetimi:** Araç özelliklerini ekle, sil veya güncelle.
*   **Rezervasyon Yönetimi:** Kiralama isteklerini görüntüle, onayla veya reddet.
*   **Muayene ve Bakım:** Yaklaşan muayene/bakım tarihlerini vurgulayan kontrol paneli.