# Aşama 1: Proje Kurulumu ve Mimari Altyapı

## 1.1. Proje Özeti
Bu proje, kullanıcıların ne yiyeceklerine karar vermelerine yardımcı olan, evdeki malzemelerle kendi tariflerini üretebildikleri Firebase destekli modern bir Flutter uygulamasıdır.

## 1.2. Teknik Kararlar
* **Frontend:** Flutter
* **State Management:** Riverpod (veya Provider) - Proje genelinde standart olarak kullanılacaktır.
* **Klasör Mimarisi:** Feature-first yaklaşımı kullanılmalıdır.
  * `lib/core/` (Temalar, sabitler, route yönetimi)
  * `lib/shared/` (Ortak widget'lar)
  * `lib/features/` (auth, home, recipe_detail, favorites, inventory, profile)

## 1.3. Tema ve UI Standartları
* **Ana Renk Paleti:** "Nutrition" konseptini andıran tatlı, çok açık olmayan bir yeşil (Soft Sage Green, Olive veya Mint Green varyasyonları).
* **Tasarım Dili:** Modern, dikkat çekici, yuvarlatılmış hatlara sahip (border-radius) kartlar.
* **Tema Desteği:** Uygulama genelinde Dark/Light tema desteği entegre edilmelidir.