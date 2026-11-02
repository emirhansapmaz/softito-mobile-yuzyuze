// Mağazadaki ürün kategorilerini tip güvenli bir şekilde listelediğimiz enum tanımımız
enum Kategori {
  // Tüm kategorileri içeren filtre seçeneği ('Tümü' başlığı ve 'H' kısaltması ile)
  hepsi('Tümü', 'H'),
  // Elektronik ürünler kategorisi
  elektronik('Elektronik', 'E'),
  // Giyim ürünleri kategorisi
  giyim('Giyim', 'G'),
  // Ayakkabı ürünleri kategorisi
  ayakkabi('Ayakkabı', 'A'),
  // Aksesuar ve takı kategorisi
  aksesuar('Aksesuar', 'AK');

  // Kategorinin ekranda görünecek Türkçe adı / başlığı
  final String baslik;
  // Kategoriye ait kısa harf kodu veya sembol
  final String ikon;

  // Kategori enum'ının değişmez kurucu metodu
  const Kategori(
    // Başlık alanını alan parametre
    this.baslik,
    // İkon / kısaltma alanını alan parametre
    this.ikon,
  // Kurucu metodun kapanış parantezi
  );
// Kategori enum'ının kapanış parantezi
}
