import '../models/post_model.dart';
import '../models/reply_model.dart';

/// Türkiye girişimcilik ekosistemine özel 13 mikro-paylaşım gönderisi
final List<PostModel> kMockPosts = [
  PostModel(
    id: 'post_1',
    authorName: 'Arda Yılmaz (Kurucu @ VeriFlow)',
    content:
        'Bugün ilk kurumsal müşterimize faturamızı kestik! 6 aylık uykusuz geceler ve 42 müşteri görüşmesinin ardından SaaS ürünümüzün değer ürettiğini görmek paha biçilemez. Yola devam!',
    likeCount: 24,
    createdAt: DateTime(2026, 10, 20, 10, 15),
    replies: [
      ReplyModel(
        id: 'rep_1',
        authorName: 'Dr. Selin Aksoy',
        content: 'Tebrikler Arda! İlk fatura en zor olanıdır, bundan sonraki süreçte retention metriklerine odaklanın.',
        createdAt: DateTime(2026, 10, 20, 10, 30),
      ),
      ReplyModel(
        id: 'rep_2',
        authorName: 'Can Tekin',
        content: 'Harika haber! Hangi ödeme altyapısını tercih ettiniz?',
        createdAt: DateTime(2026, 10, 20, 10, 45),
      ),
    ],
  ),
  PostModel(
    id: 'post_2',
    authorName: 'Melis Şen (Kurucu Ortak @ MedAI)',
    content:
        'TÜBİTAK 1512 BİGG panel sunumumuzu tamamladık. Jüri teknik altyapıyı ve klinik doğrulama planımızı çok beğendi. Sonuçları heyecanla bekliyoruz!',
    likeCount: 18,
    createdAt: DateTime(2026, 10, 20, 9, 40),
    replies: [
      ReplyModel(
        id: 'rep_3',
        authorName: 'Banu Bozkurt',
        content: 'Umarım onay çıkar, sağlık alanında harika bir değer yaratıyorsunuz!',
        createdAt: DateTime(2026, 10, 20, 9, 55),
      ),
    ],
  ),
  PostModel(
    id: 'post_3',
    authorName: 'Burak Korkmaz (CTO @ GameVerse)',
    content:
        'Mobil oyunumuzun soft-launch aşamasında D1 Retention oranı %46 çıktı! CPI maliyetleri beklediğimizden %20 daha düşük. Şimdi scale-up zamanı.',
    likeCount: 31,
    createdAt: DateTime(2026, 10, 19, 21, 10),
    replies: [],
  ),
  PostModel(
    id: 'post_4',
    authorName: 'Ece Karahan (Kurucu @ CarbonZero)',
    content:
        'ESG raporlaması yapan B2B SaaS girişimimiz için ilk tohum yatırım turumuzda 3 VC ile Term Sheet aşamasına geldik. Değerleme ve likidasyon tercihlerinde nelere dikkat etmeliyiz?',
    likeCount: 15,
    createdAt: DateTime(2026, 10, 19, 18, 20),
    replies: [
      ReplyModel(
        id: 'rep_4',
        authorName: 'İpek Kaya',
        content: 'Participating vs Non-participating liquidation preference maddesine mutlaka dikkat edin Ece hanım.',
        createdAt: DateTime(2026, 10, 19, 18, 50),
      ),
    ],
  ),
  PostModel(
    id: 'post_5',
    authorName: 'Oğuzhan Kaya (Ürün Yöneticisi)',
    content:
        'Yapay zeka asistanımızı DeepSeek ve Llama 3 modelleriyle yerel sunucularda çalıştırmaya başladık. API maliyetlerimiz bir gecede %75 azaldı!',
    likeCount: 42,
    createdAt: DateTime(2026, 10, 19, 16, 5),
    replies: [],
  ),
  PostModel(
    id: 'post_6',
    authorName: 'Selin Aydın (Kurucu @ EduOrbit)',
    content:
        'İTÜ Çekirdek kuluçka programına kabul edildik! Önümüzdeki 6 ay boyunca mentorluk ve prototipleme laboratuvarından tam kapasite faydalanacağız.',
    likeCount: 29,
    createdAt: DateTime(2026, 10, 19, 14, 0),
    replies: [],
  ),
  PostModel(
    id: 'post_7',
    authorName: 'Emirhan Sapmaz (Frontend Lideri)',
    content:
        'Flutter ile sıfır harici paket kullanarak sadece ValueNotifier mimarisiyle kurduğumuz reaktif tema ve durum yönetimi yağ gibi akıyor. Pure Dart FTW!',
    likeCount: 56,
    createdAt: DateTime(2026, 10, 19, 12, 30),
    replies: [
      ReplyModel(
        id: 'rep_5',
        authorName: 'Kaan Demir',
        content: 'Yalın mimari her zaman uzun vadede kazandırır, elinize sağlık.',
        createdAt: DateTime(2026, 10, 19, 12, 45),
      ),
    ],
  ),
  PostModel(
    id: 'post_8',
    authorName: 'Gamze Öztürk (Growth Hacker)',
    content:
        'Product Hunt lansmanında "Product of the Day" seçildik! 24 saatte 3.400 kayıt ve 120 paid kullanıcı elde ettik. Topluluğun desteği muazzamdı.',
    likeCount: 38,
    createdAt: DateTime(2026, 10, 19, 11, 0),
    replies: [],
  ),
  PostModel(
    id: 'post_9',
    authorName: 'Tolga Çelik (Fintek Danışmanı)',
    content:
        'TCMB açık bankacılık lisans başvurularında güvenlik standartları güncellendi. Banka entegrasyonu yapacak tüm girişimcilerin ISO 27001 süreçlerini gözden geçirmesi şart.',
    likeCount: 19,
    createdAt: DateTime(2026, 10, 18, 17, 45),
    replies: [],
  ),
  PostModel(
    id: 'post_10',
    authorName: 'Derya Vural (Yatırım Analisti)',
    content:
        '2026 3. Çeyrek Türkiye girişim ekosistemi raporuna göre en çok yatırım alan sektörler yine Yapay Zeka ve B2B SaaS oldu. Erken aşama yatırımlarda toparlanma başladı.',
    likeCount: 22,
    createdAt: DateTime(2026, 10, 18, 15, 20),
    replies: [],
  ),
  PostModel(
    id: 'post_11',
    authorName: 'Mert Akın (Donanım Girişimcisi)',
    content:
        'İlk parti akıllı IoT cihazımızın PCB baskılarını yerli üretimle tamamladık. Çin tedarik sürelerine göre 4 hafta tasarruf ettik. Yerli üretim gücünü hafife almayın.',
    likeCount: 27,
    createdAt: DateTime(2026, 10, 18, 13, 10),
    replies: [],
  ),
  PostModel(
    id: 'post_12',
    authorName: 'Nazlı Erdem (Hukuk & İK)',
    content:
        'Girişimlerde çalışan hisse opsiyonu (ESOP) oluştururken vesting süresini 4 yıl + 1 yıl cliff olarak kurgulamak yetenek tutundurma oranını %40 artırıyor.',
    likeCount: 33,
    createdAt: DateTime(2026, 10, 18, 10, 0),
    replies: [],
  ),
  PostModel(
    id: 'post_13',
    authorName: 'Cem Güner (Seri Girişimci)',
    content:
        'Başarısız bir girişim deneyimi, başarılı bir kurumsal kariyerden daha fazla öğretir. Yeter ki pes etmeyin ve yörüngeden kopmayın!',
    likeCount: 64,
    createdAt: DateTime(2026, 10, 17, 19, 30),
    replies: [
      ReplyModel(
        id: 'rep_6',
        authorName: 'Arda Yılmaz',
        content: 'Kesinlikle katılıyorum Cem bey, her pivot yeni bir keşif.',
        createdAt: DateTime(2026, 10, 17, 20, 0),
      ),
    ],
  ),
];
