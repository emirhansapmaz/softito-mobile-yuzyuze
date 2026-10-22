# Ana Uygulama Ekranları ve Akış Detayları

Uygulamanın ana gövdesi bir "Bottom Navigation Bar" (Alt Gezinme Çubuğu) ile 5 ana sekmeye ayrılacaktır.

## Sekme 1: Ana Ekran (Günün Görevleri)
- **Tasarım:** Sadece o güne ait alışkanlıkların listelendiği, dikkat dağıtmayan bir arayüz.
- **Fonksiyon:** 
  - Alışkanlık kartları üzerinde mevcut seri (Örn: "🔥 12 Gün") yazar.
  - Kullanıcı kartı yana kaydırarak (Swipe to complete) veya bir Checkbox/Buton yardımıyla o günkü görevi tamamlar.
  - Tamamlananlar "Bugün Bitenler" olarak alta grileşerek düşer.
- **Etkileşim (Pop-up Animasyonu):** Kullanıcı bir alışkanlığı tamamladığında ekranda şık, neon olmayan, soft renklerde bir pop-up veya animasyonlu bir diyalog penceresi belirir. 
  - *Örnek Metin:* "Tebrikler! [Alışkanlık Adı] streakiniz [X] güne ulaştı! Harika gidiyorsun." (Lottie ile ufak bir konfeti veya onay tik animasyonu eklenebilir).

## Sekme 2: Alışkanlıklar (Sağlıklı ve Zararlı)
- **Yapı:** Üstte bir `TabBar` (Sağlıklı Alışkanlıklar | Zararlı Alışkanlıklar).
- **Zararlı Alışkanlıklar (Bırakma Modülü - Özel İstek):**
  - **Ekleme Formu:** Sigara vb. eklerken "Günde kaç TL harcıyorsun?" sorusu zorunlu olmalı.
  - **Tasarruf Gösterimi:** Kartta `(Geçen Gün) x (Günlük Harcama)` formülü ile "Şu ana kadar X TL tasarruf ettin" bilgisi büyük puntolarla yazmalı.
  - **Rastgele Bilgi Kartı:** Ekranın altında otomatik dönen (Carousel) veya her açılışta değişen "Sigara/Alkolün Zararları" hakkında bilimsel gerçekler kutusu.

## Sekme 3: Liderlik Tablosu (Leaderboard)
- **Tasarım:** Rekabeti tetikleyecek, temiz tasarımlı bir sıralama listesi.
- **Üst Kısım:** Kullanıcının mevcut durumu. Örn: "Tebrikler! 10.000 kişi arasında 789. sıradasın."
- **Liste:** İlk 100 kişinin `Kullanıcı Adı`, `Seri Günü (Streak)` ve `Puanı` listelenir.
- **Puanlama Kuralı:** Sigara içilmeyen her gün için taban puan, streak uzadıkça çarpan eklenir (Örn: 10 günden sonra günlük 1.5x puan).

## Sekme 4: Başarılar ve Rozetler
- **Tasarım:** Bir galeri / kupa dolabı görünümü. Temaya uygun, minimal ikonlar.
- **Rozetler:**
  - *Seri Başarıları:* "3 Günlük Seri", "1 Haftalık İrade", "1 Aylık Şampiyon".
  - *Tasarruf Başarıları:* "İlk 100 TL Cepte", "1000 TL Tasarruf".
- **Durum:** Kazanılmayan rozetler kilit ikonuyla siyah-beyaz, kazanılanlar renkli ve animasyonlu gösterilir.

## Sekme 5: Hesap ve Uygulama Ayarları
- **Hesap Ayarları:**
  - Profil fotoğrafı değiştirme.
  - Ad, Soyad, Kullanıcı adı güncelleme.
  - Şifre değiştirme.
- **Uygulama Ayarları:**
  - Tema (Aydınlık / Karanlık / Sistem).
  - Bildirim İzinleri (Günlük hatırlatıcı saati ayarlama).
  - "Çıkış Yap" ve "Hesabımı Sil" butonları (Kırmızı renkli, uyarı diyaloglu).