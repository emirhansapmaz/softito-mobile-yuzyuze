// Standart Dart girdi/çıktı kütüphanesi
import 'dart:io';

// Future.wait örneği: Birden fazla asenkron isteği aynı anda paralel olarak başlatıp hepsinin bitmesini beklediğimiz fonksiyon
// Future<void> fetchDashboardData() async {
//   // Hata yakalama bloğu başlatıyoruz
//   try {
//     // 3 farklı servisten veriyi aynı anda paralel çekip tek bir listede topluyoruz
//     final result = await Future.wait([
//       // Kullanıcı profil bilgilerini getiren istek
//       fetchUserProfile(),
//       // Kullanıcı hesap bakiyesini getiren istek
//       fetchAccountBalance(),
//       // Kullanıcı bildirimlerini getiren istek
//       fetchNotification(),
//     // eagerError: true sayesinde isteklerden herhangi biri hata verirse beklemeden hemen catch'e düşer
//     ], eagerError: true);
//     // Tüm veriler başarıyla geldiyse konsola yazdırıyoruz
//     print("Tüm veriler geldi $result");
//   // İsteklerden biri veya birkaçı patlarsa buraya düşer
//   } catch (e) {
//     // Hatanın ne olduğunu konsola basıyoruz
//     print("İsteklerden Biri başarısız oldu $e");
//   // try-catch bloğunun kapanışı
//   }
// // fetchDashboardData fonksiyonunun kapanış parantezi
// }

// Future: Tek bir seferlik veri çekeceğimiz asenkron durumlarda kullanıyoruz (Örn: HTTP GET isteği).
// Stream: Bir boru hattı (Pipe) gibi çalışır; zaman içinde parça parça 1, 10, 100 ya da sonsuz sayıda veri akışı sağlar.
// Gerçek hayattaki örnekleri: Canlı borsa fiyatları, GPS anlık konum takibi, Firebase Firestore canlı dinleme.

// Zamanlayıcılar, Stream ve asenkron programlama araçlarını sağlayan kütüphane
import 'dart:async';

// Uygulamanın başladığı ana giriş fonksiyonumuz
void main() {
  // Tam sayı (int) türünde veri akışı sağlayacak StreamController nesnemizi oluşturuyoruz
  final controller = StreamController<int>();

  // Stream borusunu dinlemeye (listen) başlıyoruz; her yeni veri geldiğinde burası tetiklenir
  final subscription = controller.stream.listen(
    // Borudan yeni bir tam sayı aktığında çalışan fonksiyon
    (data) => print("yeni veri: $data"),
    // Akış sırasında bir hata fırlatılırsa çalışan hata yakalama bloğu
    onError: (err) => print("Hata Oluştu: $err"),
    // Akış controller.close() ile sonlandırıldığında çalışan tamamlandı bloğu
    onDone: () => print("Yayın Tamamlandı"),
  // listen metodunun kapanış parantezi
  );

  // Boru hattının giriş ucuna (sink) ilk verimiz olan 10 sayısını gönderiyoruz
  controller.sink.add(10);
  // Boru hattına ikinci veri olarak 20 sayısını gönderiyoruz
  controller.sink.add(20);
  // Boru hattına üçüncü veri olarak 30 sayısını gönderiyoruz
  controller.sink.add(30);
  // Artık yeni veri göndermeyeceğimiz için yayını kapatıyoruz (onDone tetiklenir)
  controller.close();
// main fonksiyonunun kapanış parantezi
}
