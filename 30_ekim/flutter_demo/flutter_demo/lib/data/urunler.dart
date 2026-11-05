 class Urun {
  final String id;
  final String ad;
  final double fiyat;


  const Urun({
    required this.id,
    required this.ad,
    required this.fiyat,

  });
}

final List<Urun> urunler = [
  const Urun(
    id: '1',
    ad: 'Messi',
    fiyat: 8000000000,

  ),
  const Urun(
    id: '2',
    ad: 'Ronaldo',
    fiyat: 5,
 
  ),
];