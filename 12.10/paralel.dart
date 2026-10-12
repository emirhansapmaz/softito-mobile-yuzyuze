import 'dart:io';
/*
Future<void> fetchDashboardData() async {
  try {
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);

    print("Tüm veriler geldi $result");
  } catch (e) {
    print("İsteklerden Biri başarısız oldu $e");
  }
}

  */

//Future:Tek bir kere veri çekeceğimiz zaman kullanıyoruz.
//Stream:Bir boru hattı şeklinde çalışır(Pipe), Zaman içinde 1 10 100 ya da sunsuz sayıda veri akışı sağlanabilir.
//borsa fiyatları GPS Konum güncelleme, firebase canlı dinleme

import 'dart:async';

void main(){
  final controller=StreamController<int>();
  final subscription=controller.stream.listen((data)=>print("yeni veri: $data"),
  on error: (err)=>print("Hata Oluştu: $err"),
  onDone: () => print("Yayın Tamamlandı"),);

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);
  controller.close();

}