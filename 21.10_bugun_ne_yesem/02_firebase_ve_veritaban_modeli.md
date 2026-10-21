# Aşama 2: Firebase Entegrasyonu ve Veritabanı Modeli

## 2.1. Kullanılacak Servisler
* Firebase Authentication (E-posta/Şifre, Google, Apple)
* Cloud Firestore (Veri depolama)

## 2.2. Firestore Koleksiyon Yapıları
* **`users`:**
  * `uid`, `name`, `email`, `phone`, `passwordHint` (Kolay giriş için metin ipucu veya fotoğraf URL'si).
* **`recipes` (Hazır Yemekler):**
  * `id`, `name`, `description`, `ingredients` (List), `calories` (int), `servingSuggestion`, `pairsWellWith` (Yanında iyi gider önerisi string'i), `imageUrl`.
* **`user_favorites`:**
  * `userId`, `recipeId` (Referans ID listesi).
* **`user_inventory`:**
  * `userId`, `ingredients` (Kullanıcının evindeki malzemelerin String listesi).
* **`chef_recipes` (Masterchef Üretimi):**
  * `id`, `userId`, `name`, `ingredients`, `calories`, `steps`, `createdAt`.