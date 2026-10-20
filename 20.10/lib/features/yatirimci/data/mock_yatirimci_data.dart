import '../models/yatirimci_model.dart';

/// Türkiye girişimcilik ekosistemine özel 16 gerçekçi yatırımcı profili
/// Kota: 4 Şirket, 4 Holding, 4 Melek Yatırımcı, 4 VC
const List<YatirimciModel> kMockYatirimcilar = [
  // --- 4 Adet Şirket (Corporate CVC) ---
  YatirimciModel(
    id: 'y1',
    name: 'Turkcell Ventures',
    type: 'Şirket',
    investmentStage: 'Tohum',
    ticketSize: r'$250K - $1M',
    targetSectors: ['Telekom', 'Yapay Zeka', 'SaaS', 'IoT'],
    description:
        'Telekomünikasyon, yapay zeka ve bulut teknolojilerinde stratejik sinerji üreten girişimlere kurumsal fon desteği.',
    websiteUrl: 'https://turkcellventures.com.tr',
  ),
  YatirimciModel(
    id: 'y2',
    name: 'Akbank LAB Ventures',
    type: 'Şirket',
    investmentStage: 'Seri A',
    ticketSize: r'$500K - $2M',
    targetSectors: ['Fintek', 'Açık Bankacılık', 'Siber Güvenlik'],
    description:
        'Finansal kapsayıcılık ve yeni nesil ödeme teknolojilerine odaklanan kurumsal girişim sermayesi fonu.',
    websiteUrl: 'https://akbanklab.com',
  ),
  YatirimciModel(
    id: 'y3',
    name: 'Vestel Ventures',
    type: 'Şirket',
    investmentStage: 'Tohum',
    ticketSize: r'$100K - $500K',
    targetSectors: ['Donanım', 'Tüketici Elektroniği', 'Temiz Enerji'],
    description:
        'Akıllı ev teknolojileri, mobilite ve batarya inovasyonu yapan teknoloji girişimlerini destekler.',
    websiteUrl: 'https://vestelventures.com',
  ),
  YatirimciModel(
    id: 'y4',
    name: 'Trendyol Tech Fund',
    type: 'Şirket',
    investmentStage: 'Seri A',
    ticketSize: r'$500K - $3M',
    targetSectors: ['E-ticaret', 'Lojistik', 'Pazaryeri', 'AdTech'],
    description:
        'E-ticaret altyapısını güçlendiren lojistik optimizasyonu ve perakende teknolojilerine büyüme yatırımları.',
    websiteUrl: 'https://trendyol.com/techfund',
  ),

  // --- 4 Adet Holding ---
  YatirimciModel(
    id: 'y5',
    name: 'Koç Holding Inovasyon Masası',
    type: 'Holding',
    investmentStage: 'Seri A',
    ticketSize: r'$1M - $5M',
    targetSectors: ['Otomotiv', 'Enerji', 'Endüstri 4.0', 'Fintek'],
    description:
        'Sanayi dönüşümü, sürdürülebilir enerji ve küresel ölçekleme potansiyeli yüksek teknoloji girişimleri.',
    websiteUrl: 'https://koc.com.tr/inovasyon',
  ),
  YatirimciModel(
    id: 'y6',
    name: 'Sabancı Ventures',
    type: 'Holding',
    investmentStage: 'Tohum',
    ticketSize: r'$500K - $2M',
    targetSectors: ['İleri Malzemeler', 'İklim', 'Dijital Sağlık'],
    description:
        'Yeni nesil sürdürülebilirlik, kompozit malzemeler ve enerji verimliliği odaklı holding fonu.',
    websiteUrl: 'https://sabanciventures.com',
  ),
  YatirimciModel(
    id: 'y7',
    name: 'Eczacıbaşı Momentum',
    type: 'Holding',
    investmentStage: 'Tohum',
    ticketSize: r'$250K - $1M',
    targetSectors: ['Dijital Sağlık', 'Yapı Teknolojileri', 'SaaS'],
    description:
        'Sağlık teknolojileri, medikal teşhis ve tüketici sağlığında erken aşama yenilikçi çözümler.',
    websiteUrl: 'https://eczacibasimomentum.com',
  ),
  YatirimciModel(
    id: 'y8',
    name: 'Zorlu Ventures',
    type: 'Holding',
    investmentStage: 'Seri B+',
    ticketSize: r'$2M - $8M',
    targetSectors: ['Akıllı Şehirler', 'Mikromobilite', 'Yenilenebilir Enerji'],
    description:
        'Akıllı yaşam, elektrikli araç şarj ağları ve temiz enerji ekosistemini hızlandıran büyük ölçekli yatırımlar.',
    websiteUrl: 'https://zorluventures.com',
  ),

  // --- 4 Adet Melek Yatırımcı ---
  YatirimciModel(
    id: 'y9',
    name: 'Galata Business Angels (GBA)',
    type: 'Melek Yatırımcı',
    investmentStage: 'Ön Tohum',
    ticketSize: r'$50K - $250K',
    targetSectors: ['Yazılım', 'Pazaryeri', 'EdTech', 'Fintek'],
    description:
        'Türkiye’nin ilk melek yatırımcı ağı; güçlü mentorluk ve küresel ağ erişimi sunan çekirdek sermaye.',
    websiteUrl: 'https://galataba.com',
  ),
  YatirimciModel(
    id: 'y10',
    name: 'Arya Women Investment Platform',
    type: 'Melek Yatırımcı',
    investmentStage: 'Ön Tohum',
    ticketSize: r'$30K - $150K',
    targetSectors: ['Kadın Girişimciliği', 'Sosyal Etki', 'Sağlık', 'B2B SaaS'],
    description:
        'Kadın liderliğindeki girişimleri ve toplumsal fayda yaratan inovatif iş modellerini güçlendiren melek fon.',
    websiteUrl: 'https://aryawomen.com',
  ),
  YatirimciModel(
    id: 'y11',
    name: 'TR Angels',
    type: 'Melek Yatırımcı',
    investmentStage: 'Tohum',
    ticketSize: r'$75K - $300K',
    targetSectors: ['Derin Teknoloji', 'Siber Güvenlik', 'Yapay Zeka'],
    description:
        'Akademik ve derin teknoloji girişimlerine odaklı, patentli fikirleri sanayiye bağlayan melek ağı.',
    websiteUrl: 'https://trangels.com',
  ),
  YatirimciModel(
    id: 'y12',
    name: 'Nevzat Aydın Melek Portföyü',
    type: 'Melek Yatırımcı',
    investmentStage: 'Tohum',
    ticketSize: r'$100K - $500K',
    targetSectors: ['FoodTech', 'Oyun', 'Pazaryeri', 'Web3'],
    description:
        'Yemeksepeti kurucusunun doğrudan ölçeklenme ve global pazara açılma odaklı erken aşama yatırımları.',
    websiteUrl: 'https://angel.co/nevzataydin',
  ),

  // --- 4 Adet VC (Girişim Sermayesi) ---
  YatirimciModel(
    id: 'y13',
    name: '212 Capital Partners',
    type: 'VC',
    investmentStage: 'Seri A',
    ticketSize: r'$1M - $4M',
    targetSectors: ['B2B SaaS', 'Bulut', 'Fintek', 'Büyük Veri'],
    description:
        'Türkiye ve Doğu Avrupa’dan çıkan, küresel B2B SaaS pazarını hedefleyen yüksek büyüme potansiyelli girişimler.',
    websiteUrl: 'https://212.vc',
  ),
  YatirimciModel(
    id: 'y14',
    name: 'Earlybird Digital East Fund',
    type: 'VC',
    investmentStage: 'Seri B+',
    ticketSize: r'$3M - $10M',
    targetSectors: ['Yapay Zeka', 'Enterprise Tech', 'Siber Güvenlik'],
    description:
        'UiPath ve Trendyol gibi decacorn hikayelerine erken aşamada liderlik eden küresel girişim sermayesi fonu.',
    websiteUrl: 'https://earlybird.com',
  ),
  YatirimciModel(
    id: 'y15',
    name: 'Revo Capital',
    type: 'VC',
    investmentStage: 'Seri A',
    ticketSize: r'$1.5M - $5M',
    targetSectors: ['Fintek', 'B2B SaaS', 'HealthTech'],
    description:
        'Cortex ve B2B çözümleriyle globalleşen teknoloji girişimlerine sermaye ve operasyonel destek sağlar.',
    websiteUrl: 'https://revo.vc',
  ),
  YatirimciModel(
    id: 'y16',
    name: 'Collective Spark',
    type: 'VC',
    investmentStage: 'Tohum',
    ticketSize: r'$300K - $1.5M',
    targetSectors: ['Oyun', 'Fintek', 'Web3', 'SaaS'],
    description:
        'Kurucuların yanında ilk kurumsal çekirdek turda yer alarak ürün-pazar uyumuna ivme kazandıran dinamik VC.',
    websiteUrl: 'https://collectivespark.com',
  ),
];
