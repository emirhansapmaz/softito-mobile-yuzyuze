# Dijital Günlük Uygulaması
Bu döküman Flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

# 1. Project Özeti ve Teknolojiler
- **Uygulama adı:** Dijital Günlük (Takvimli akıllı günlük ve anı takip uygulaması)
- **Hedef Platformlar:** Ios ve android öncelikli ardından web ve masaüstü platformları.
- **Flutter SDK:** 3.29.0
- **Dart SDK:** 3.0.0
- **Tasarım Dili:** Material 3, Çift Tema Desteği:
  - **Koyu Tema (Dark Mode):** Gece okuma/yazma paleti (Koyu Kağıt Dokusu & Soft Mavi / Gece Grisi).
  - **Aydınlık Tema (Light Mode):** Gündüz günlük paleti (Temiz Kağıt Beyazı & Mürekkep Mavisi / Soft Krem).
  - Tema değişimi yerleşik `ValueNotifier<ThemeMode>` mimarisi ile sıfır harici paket kullanılarak reaktif yönetilir.

---

## 2. Mimari Yapı : Özellik bazlı 
Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
core/
extension'lar
    constants/app_colors.dart
    theme/app_theme.dart
    theme/theme_controller.dart

    features/
        calendar/
            controller/
            models/
            view/
            widget/
        diary_entry/
            controller/
            models/
            view/
            widget/
        statistics/
            controller/
            models/
            view/
            widget/

    main.dart

```

#### sadece uygulama başlatma ve tema bölümleri

## 3. Kırmızı çizgiler kod kalite standartları

1- **State Yönetim Standartları:**
Sayfa düzeyinde ağır 'setState' KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2- **UI ve Performans kuralları:**
Statik ve tüm widget'larda 'const' zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır.

3- **Yasaklı Paketler:**
Projeye onay almadan harici ağır state Paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 4. Geliştirme analiz ve test komutları

Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik kod analizi (0 uyarı ve 0 hata şart):**
```bash
flutter test
```
* **Projeyi çalıştırma:**
```bash
flutter run
```

## 5. Ajanın çıktı ve yanıt verme standartları

- **Açıklama:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
- **Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sonra basma, hedef satırları ve diff yapısını göster.
- **Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
- **Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.

---

- **Statistics (Yazma Alışkanlığı ve Seriler):** Kullanıcının her gün yazı yazma hedeflerine ulaştığında kazandığı başarımları (örneğin: "Kesintisiz Yazar", "Gece Kuşu") ve günlük serilerini (streak) takip eden modül. Arayüz bileşenleri (rozetler, ilerleme çubukları) tamamen Koyu/Aydınlık Tema ve belirlenen renk paleti kurallarına sadık kalınarak, [lib/features/statistics](lib/features/statistics) dizini altında izole olarak geliştirilir.

**LOGO TASARIMI**

Uygulama logosu: Uygulamanın en altında yer alacaktır. İç içe geçmiş dairesel bir yapıdadır. Dış daire koyu mürekkep rengi, iç daire ise soft krem rengindedir. İç dairenin içinde dikey olarak yerleştirilmiş zarif bir dolma kalem ucu bulunur. Bu kalem ucunun içi soft mavi rengindedir ve sağ üst köşesine doğru hafif eğimlidir. Ayrıca, kalem ucundan başlayarak dairesel çizginin kenarına doğru uzanan küçük bir mürekkep damlası efekti vardır. Günlük tutma mantığına da uygun olmalı, nostaljik ama modern bir yazar hissi vermeli. Mesela kalem ucunun içinde yansıma efekti ile bir takvim yaprağı hissi verilebilir. Yani zaman (takvim) ile yazı (kalem) birleşmeli ve estetik bir görüntü oluşturulmalı. Logonun genel atmosferi modern, edebi ve temiz bir estetiğe sahiptir. Altında yer alan yazı ise uygulamanın adı olan "GÜNLÜĞÜM" (veya "DİJİTAL GÜNLÜK") kelimesidir. Ayrıca bu logoyu telefonda tıkladığımız ikonda da görelim.