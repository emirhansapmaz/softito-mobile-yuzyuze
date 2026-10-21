# Aşama 4: İş Mantığı ve Algoritmalar

## 4.1. Gümüş Kubbe ve Rastgele Yemek Seçimi
* "Kendimi Şanslı Hissediyorum" butonuna basıldığında:
  1. `recipes` koleksiyonundan veri çekilir.
  2. Lottie gümüş kubbe animasyonu tetiklenir (titreme ve açılma efekti).
  3. Rastgele bir yemek (`Random().nextInt`) seçilir ve animasyon bitiminde ekranda gösterilir.

## 4.2. Masterchef Üretim Mantığı
* Kullanıcı `user_inventory`'deki mevcut malzemelerden Checkbox/Chip ile çoklu seçim yapar.
* Dışarıdan manuel olarak kalori ve adım bilgisi girer.
* "Yemek Üret" dendiğinde bu veri `chef_recipes` koleksiyonuna kaydedilir ve Tab 4'te (Şefin Yemekleri) anında güncellenir (Stream veya State Provider ile).

## 4.3. Arama ve Filtreleme
* Favorilerim sayfasındaki Search Bar, eldeki `user_favorites` listesinde anlık olarak metin bazlı (contains) filtreleme yapmalıdır.