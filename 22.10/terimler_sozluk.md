Const
1) ne işe yarar: İçine girilen değerleri derleme zamanında tek bir kere yazılarak değişmez olarak üretir.
2) Neden kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widget'ı yeniden üretmez ve pil tasarrufu sağlar.

final
1) Ne işe yarar : çalışma zamanında değer bir kez atanan ve sonrasında referansı asla değiştirilmeyen değişkenler

*-const ve final arasındaki fark?
    lconst derlenirken bilinmek zorunda(const: pi=3.14) final ise çalışma anında ve belirlenebilir (final saat = Datetime.now())---Model sınıflarında alanlar her zaman final olmalıdır.---

 late
1) Ne işe yarar: değişen tanımlandığı anda değil, ilk kullanıldığında veya inisState anında başlayanılacağı zaman kullanılır.

required
1) ne işe yarar: isimlendirilmiş parametrelerde o parametrenin(değişkenin) zorunlu olduğunu belirtir.

override
1) ne işe yarar: Bir widget veya method'un özelliklerini değiştirmek için kullanılır. Alt sınıfın üst sınıftan devraldığı metodu ezdiğini bildirir.
faydası: eğer üst metot adını yanlış yazarsanız (örnek builds yazarsanız) derleyici @override sayesinde bunu anında hata olarak yakalar.

Null-aware operatörleri (? ?? !)
?. - place?.title -> Place null ise hata vermez direkt null olarak döner.
?? - if null : final if = state.userIdm?? 10; -> sol taraf null ise sağdaki (hardcode olan değer) otomatik olarak atanır.
! (null / force): final id = state.userId ! -> bu kod derleyiciye "bana güven bu değer o anda kesinlikle null değil" der. eğer null gelir ise uygulama anında çöker.(ÇOK DİKKATLİ KULLANILMALI !!!)

Spread operatörü(...)
1) ne işe yarar : bir listenin elemanlarını tek tek çıkartıp bulunduğu üst listenin içine ekler.
Column ve ListView içinde dinamik kart dizini kullanmak için en temiz yöntemdir.
...listeAdi.map((p)=>_buildCard(p))

initState()
1) ne zaman çalışır : widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır.
2) ne yapar : ScrollController başlatmaları ve ilk api istekleri burada kurulur.
kural: içinde doğrudar BuildContext ile Navigator çağırılmaz .ünkü widget ağaca tam oturmamıştır.
didChangeDependencies()
ne zaman çalışır: initState()'ten hemen sonra (örnek: Theme.of (context) ) değiştiğinde otomatik tetikler.
build(BuildContext context)
Ne zaman çalışır: Sayfa ilk açıldığında, setState() çağırıldığında veya üst widget yeni bir inşa ağaç boyama geldiğinde saniyesinde defalarca çalışır.
Kural: build() metodu tamamen saf olmalıdır. Asla içinde setState() api isteği ya da controller başlatma yapılmamalıdır. Sadece UI döndürülmelidir.

dispose()
ne zaman çalışır: widget hafızadan atılmadan hemen önce son bir kez çalışır
ne yapılır: _controller.dispose() stream dinleyicilerin iptalleri burada yapılır. super.dispose()un mutlaka son satırda çalıştırılması gerekir.

setState((){})
1) arka planda ne yapar. State'in bağlı olduğu StatefulElement nesnesine "ben değiştim, build et" sinyali yollar
2) nerede kullanılır. sayfa genelini çizidrmez. sadece onu dinleyen küçük ValueListenableBuilder'a sinyal gönderilir.


ValueNotifier<T>
1) arka planda ne iş yapar: ChangeNotifier sınıfından türer. Belleğinde tek bir nesne referansı tutar(T_value)
2) Tetikleme Değer Atandığında (Set value(T value)),eğer yeni değer eski değere eşit değilse (_value!=newValue), kayıtlı olan fonksiyonu çağrılır. (addListener(() {}))

InheritedWidget
1) ne yapar: widget ağacında alttaki childların, aradaki onlarca widgeti bypass ederek, üst widgetin verisine(state'ine) doğrudan erişmesini sağlayan soyut bir widgettir.

Material 3 Tasarım Dili Renk Algoritması ve temalar

primary: aNA MARKA RENGİ
onPrimary: Ana rengin üstüne yazılacak yazı rengi(okunabilirlik için.)
primaryContainer: Ana rengin açık tonu
onPrimaryContainer: Ana rengin açık tonunun üstüne yazılacak yazı rengi(okunabilirlik için.)
surface:Sayfa üstündeki ana metin rengi
outlineVariant:İnce sınır ve ayrım çizgilerinin rengi

Theme.Mode.system
color:Colors.black.withOpacity(186) //kesinlikle 1 ila 255 arasında bir değer olmalı.

color:Colors.black.withValues(alpha: 186/255) //Kesinlikle 0.0 ile 1.0 arasında bir değer olmalı.

Arayüz Düzen ve Liste Bileşenleri

Expanded ve Flexible

Expanded: Kalan boş alanın tamamını kaplamaya zorlar.
Flexible:Kalan bol alanı paylaştırır.(flex:1,flex2)
Flex: yanyana iki expanded varsa birine flex2 diğerine flex1 veirr bu sayede ekran boyutuna göre otomatik olarak ayarlar.

Stack ve Positioned

Widgetları z ekseninde üst üste bindirir.
Positioned: Yalnızca bir stack içinde çalışır.
örnek: top:10, right:10 verecek bir resmin sağ üst köşesine bildirim rozeti eklememizi sağlar.

listView.builder.
Klasik ListView(children:[...]) içindeki örnek vermek gerekirse 10.000 elemanın tamamını daha sayfa açılmadan belleğe yükler ve doğal olarak telefon donar.
Listview.builder ise Gerş Dönüşümlü Görünüm alanı mantığını kullanarak ekranda sadece o an eğer 5 kart görünecek ise sadece 5 kartı ram belleğe yükler. Kullanıcı aşağıya kaydıkça yukarıda kalanlar bellekten düşürülüp altta kalanlar belleğe taze olarak yeni olarak üretilir.

shrinkWrap: true
1) Bir ListView baş bir dikey kaydırıcının (singleChildScrollView) içine konursa Vertical viewport hatası verir.

shrinkWrap true verilerek bu çözülebilir ancak:ListView'un sonsuza kayma (sonsuz scroll) özelliği kaybolur. 
**Sadece 3 5 elemanınız varsa bunu kullanmamalısınız**

Inkwell ve GestureDetector
GestureDetector : Tıklama çift tıklama sürükleme olaylarını yakalar ama GÖRSEL HİÇBİR TEPKİ VERMEZ.
Inkwell: Sadece tıklama olayını yakalar ama dokunulan alanın etrafında o ana renk etrafında yayılan bir dalga (splash) efekti oluşturur.

önemli kural: Inkwell'in arkasında mutlaka bir material widget olmak zorundadır. Aksi takdirde su dalgası arkadaş tuvali göremediği için hiçbir şekilde görünmez.
  
  Form Mimarisi

  GlobalKey<FormState> 
  Widget içindeki Form düğümüne doğrudan dışarıdan erişikemşyor. Bu yüzden widgetin en üstüne koyduğumuz globalKey değişkeni sayesinde formun Validate (geçerli) durumunu ve içindeki değerleri (Değişkenleri) dışarıdan okuyoruz.

  _formKey.currentState?.validate() çağırıldığında o formun altındaki tüm TextFromFiled validator bloklarını sırayla çalıştırır.

  validator: (String ? value)
  fonksiyonda bir hata bulursa geriye String olarak hata metni döndürür.
  Bu metin otomatik olarak kırmızı renkte ve inputun altında belirir.
  Eğer veri geçerliyse null döner.Flutter için bu alanda hata yok demektir. Null gelmesi.

  Animasyon Motoru

  AnimatedContainer:genişlik yükseklik padding margin border renk ve gölge oynatır.
  AnimatedOpacity: görünürlüğü 0.0 ila 1.0 arasında yumuşakça soldurur.
  AnimatedScale: widget merkezinden dışarıya doğru büyütüp küçültür.
  AnimatedAlign:widget kutunun içinde sağdan sola yukarıdan aşağıya karşı konumunu değiştirir.

  Curves

  Curves.linear:Sabit hız(robotik hareketler)
  Curves.easeInout: yavaş başlar ortada hızlanır yavaşça durur
  Curves.bounceout: hedefe çarptığında top gibi 2 3 kez yaylanarak seker
  Curves.elasticOut: lastik gibi ileri geri titreyerek yerine oturur.

  ivmeleme karakterleri

  curves.linear:
  curves.easeInOut:
  curves.bounceOut:
  curves.elasticOut:

Gorouter

context.go('/profil): route yönlendirmesidir. rota tablosunda hiyerarşiyi takip eder sayfayı temizleyebilir.

context.push('/profil'5): route yönlendirmesidir. rota tablosunda hiyerarşiyi takip etmez stacke yığar.   
context.pop() sayfanın en üstteki yığınını kapatır.
state.pathParameters["id"]: Gorouter içinde tanımladığımız /:id yapılarına erişmek için kullanılır.

/profil?user=berat
state.uri.queryParameters["user"]: Opsiyonel filtreleme ya da arama zamanlarında kullanılır.

Cihaz içi Yerel Depolama mimarileri

SharedPreferences:
Küçük kullanıcı ayarları
düşük güvenilirlik
okuma yazma hızları: Orta / yazma hızı yavaş


FlutterSecureStorage:
Şifre token vb. saklama
en yüksek güvence
okuma yazma hızı: orta / orta




hive/Isar:
Yüksek performanslı nesne depolama
Orta (isteğe bağlı şifreleme açılabilir)
Okuma yazma hızı: çok yüksek/çok yüksek 
