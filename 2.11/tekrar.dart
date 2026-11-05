// MÜLAKAT İÇİN ÖNEMLİ: Sealed sınıflar dışarıdan extend edilmez. 
// switch içinde tüm alt sınıflar tüketilmek zorundadır (Exhaustive checking).
sealed class OdemeDurumu {}

class OdemeBasarili extends OdemeDurumu {
  final ({String referansKodu, double tutar}) veri; 
  OdemeBasarili(this.veri);
}

class OdemeBasarisiz extends OdemeDurumu {
  final String hataNedeni;
  OdemeBasarisiz(this.hataNedeni);
}

abstract class IBankaServisi {
  Future<OdemeDurumu> odemeYap({required double miktar}); 
}

mixin GuvenlikDenetimiMixin {
  bool tokenGecerliMi(String token) {
    return token.isNotEmpty && token.length >= 32;
  }
}

mixin AuditLogMixin {
  void islemKaydet(String mesaj) {
    final zaman = DateTime.now().toIso8601String(); 
    print('log - $zaman : $mesaj');
  }
}

class GarantiBankasiServisi with GuvenlikDenetimiMixin, AuditLogMixin implements IBankaServisi {
  final String apiAnahtari;
  GarantiBankasiServisi({required this.apiAnahtari});

  @override
  Future<OdemeDurumu> odemeYap({required double miktar}) async {
    if (!tokenGecerliMi(apiAnahtari)) {
      islemKaydet('Odeme Reddedildi. Geçersiz Api Anahtarı');
      return OdemeBasarisiz('Yetkilendirme Hatası: Geçersiz token');
    }
    
    await Future.delayed(const Duration(milliseconds: 1000));
    islemKaydet('$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLANDI');
    return OdemeBasarili((referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}', tutar: miktar));
  }
}

void odemeSonucunuEkranaBas(OdemeDurumu durum) {
  
  final mesaj = switch (durum) {
    OdemeBasarili b => 'Ödeme Başarılı. Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar} ₺',
    OdemeBasarisiz h => 'Ödeme Başarısız. Sebep: ${h.hataNedeni}',
  };
  print(mesaj);
}

void main() async {
  final garantiServisi = GarantiBankasiServisi(apiAnahtari: 'abc123_bu_api_anahtari_otuz_iki_karakterden_uzundur_123');
  final durum = await garantiServisi.odemeYap(miktar: 100);
  odemeSonucunuEkranaBas(durum);
}
