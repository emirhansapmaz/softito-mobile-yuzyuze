import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SepetKontrolu {
  static final SepetKontrolu ornek = SepetKontrolu._dahili();
  SepetKontrolu._dahili();

  final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

  void sepeteEkle() {
    urunSayisi.value++;
  }

  void sepetSifirla() {
    urunSayisi.value = 0;
  }
}

final GoRouter uygulamaRotalari = GoRouter(
  initialLocation: '/vitrin', // Tanımlı olmayan '/anasayfa' yerine '/vitrin' olarak düzeltildi
  routes: [
    ShellRoute( // ShellRouter yerine ShellRoute olmalı
      builder: (BuildContext context, GoRouterState state, Widget child) { // GorouterState -> GoRouterState ve eksik ':' düzeltildi
        return AnaKasaEkrani(ekranGovdesi: child);
      },
      routes: [
        GoRoute(
          path: '/vitrin',
          builder: (context, state) => const VitrinEkrani(),
        ),
        GoRoute(
          path: '/profil', // '/profil,' kısmındaki hatalı tırnak ve virgül düzeltildi
          builder: (context, state) => const ProfilEkrani(),
        ),
      ],
    ),
  ],
);

class AnaKasaEkrani extends StatelessWidget {
  final Widget ekranGovdesi;
  const AnaKasaEkrani({super.key, required this.ekranGovdesi});

  // Sınıf dışındaki fonksiyon, sınıfın içine taşındı
  int _aktifIndexiBul(BuildContext context) {
    final String konum = GoRouterState.of(context).uri.toString();
    if (konum.startsWith('/profil')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) { // Eksik süslü parantez eklendi
    return Scaffold(
      body: ekranGovdesi,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aktifIndexiBul(context),
        onDestinationSelected: (yeniIndeks) {
          if (yeniIndeks == 0) context.go('/vitrin');
          if (yeniIndeks == 1) context.go('/profil');
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.store), 
            label: 'Vitrin',
          ),
          NavigationDestination(
            icon: ValueListenableBuilder<int>(
              valueListenable: SepetKontrolu.ornek.urunSayisi,
              builder: (context, sayi, child) {
                return Badge(
                  label: Text('$sayi'),
                  isLabelVisible: sayi > 0,
                  child: const Icon(Icons.person),
                );
              },
            ),
            label: 'Profil',
          ),
        ],
      ),
    ); 
  }
}

class VitrinEkrani extends StatelessWidget {
  const VitrinEkrani({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canlı Vitrin(ValueNotifier)')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            SepetKontrolu.ornek.sepeteEkle();
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sepete Ürün Ekle(+1)'),
        ),
      ),
    );
  }
}

class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Profili')),
      body: Center(
        child: TextButton(
          onPressed: () => SepetKontrolu.ornek.sepetSifirla(),
          child: const Text('Sepeti Temizle(0 yap)'),
        ),
      ),
    );
  }
}
