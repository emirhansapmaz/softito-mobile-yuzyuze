import '../models/program_model.dart';

/// Türkiye girişimcilik ekosistemine özel 15 destek programı
/// Kota: 5 kategori x 3 program (Hibe, Devlet Desteği, Yurtdışı, Özel Fon, Kuluçka)
final List<ProgramModel> kMockProgramlar = [
  // --- 3 Adet Hibe ---
  ProgramModel(
    id: 'p1',
    title: 'TÜBİTAK 1512 BİGG Yatırım Tabanlı Girişimcilik',
    provider: 'TÜBİTAK',
    category: 'Hibe',
    status: ProgramStatus.open,
    deadline: DateTime(2026, 11, 30),
    description:
        'Teknoloji ve yenilik odaklı iş fikirlerinin ticari değere dönüşmesini sağlayan 900.000 TL hibe ve fon sermayesi desteği.',
    applicationSteps: [
      'Uygulayıcı kuruluş üzerinden çevrim içi iş fikri başvurusu yapılması',
      'İş planı hazırlığı ve mentorluk sürecinin tamamlanması',
      'TÜBİTAK panel değerlendirmesinde sunum (Pitching) yapılması',
      'Şirketleşme ve hibe sözleşmesinin imzalanması',
    ],
  ),
  ProgramModel(
    id: 'p2',
    title: 'TTGV İklim ve Temiz Teknolojiler Hibe Çağrısı',
    provider: 'TTGV',
    category: 'Hibe',
    status: ProgramStatus.upcoming,
    deadline: DateTime(2026, 12, 15),
    description:
        'Sürdürülebilirlik, su verimliliği ve karbon yakalama odaklı erken aşama Ar-Ge projelerine geri ödemesiz hibe.',
    applicationSteps: [
      'Proje ön bilgi formunun portala yüklenmesi',
      'Teknik fizibilite ve etki analizi raporunun sunulması',
      'Uzman komite mülakatı',
    ],
  ),
  ProgramModel(
    id: 'p3',
    title: 'Horizon Europe EIC Accelerator Hibesi',
    provider: 'Avrupa İnovasyon Konseyi',
    category: 'Hibe',
    status: ProgramStatus.closed,
    deadline: DateTime(2026, 9, 15),
    description:
        'Derin teknoloji ölçeklenme aşamasındaki girişimlere 2.5M€ hibe ve 15M€ doğrudan öz sermaye yatırımı.',
    applicationSteps: [
      '3 dakikalık video ve slayt desteğiyle kısa başvuru',
      'Tam iş planı ve finansal projeksiyon teslimi',
      'Brüksel jüri sunumu ve onay',
    ],
  ),

  // --- 3 Adet Devlet Desteği ---
  ProgramModel(
    id: 'p4',
    title: 'KOSGEB Ar-Ge, Ür-Ge ve İnovasyon Desteği',
    provider: 'KOSGEB',
    category: 'Devlet Desteği',
    status: ProgramStatus.open,
    deadline: DateTime(2026, 12, 31),
    description:
        'Yeni ürün ve süreç geliştirme odaklı KOBİ ve girişimcilere makine, teçhizat ve nitelikli personel gideri teşviki.',
    applicationSteps: [
      'e-Devlet ile KOSGEB KOBİ Bilgi Sistemi kaydı',
      'Ar-Ge/İnovasyon proje teklif formunun doldurulması',
      'Kurul değerlendirmesi ve proje onay süreci',
      'Harcalama ve hak ediş izleme sistemi',
    ],
  ),
  ProgramModel(
    id: 'p5',
    title: 'Ticaret Bakanlığı E-Turquality (Bilişimin Yıldızları)',
    provider: 'Ticaret Bakanlığı',
    category: 'Devlet Desteği',
    status: ProgramStatus.open,
    deadline: DateTime(2026, 11, 15),
    description:
        'Yazılım, oyun ve SaaS şirketlerinin global pazara açılması için dijital reklam, vize ve yurt dışı ofis destekleri.',
    applicationSteps: [
      'Şirket inceleme ve bilişim sektörü uygunluk denetimi',
      'Yıllık global pazarlama planının bakanlığa sunulması',
      'Onaylı harcamaların %70 oranında geri ödenmesi',
    ],
  ),
  ProgramModel(
    id: 'p6',
    title: 'Sanayi ve Teknoloji Bakanlığı Teknogirişim Desteği',
    provider: 'Sanayi Bakanlığı',
    category: 'Devlet Desteği',
    status: ProgramStatus.closed,
    deadline: DateTime(2026, 8, 30),
    description:
        'Teknopark bünyesinde faaliyet gösteren yüksek teknoloji şirketlerine vergi muafiyeti ve teşvik paketi.',
    applicationSteps: [
      'Teknoloji Geliştirme Bölgesi (TGB) kabul onayı',
      'Bakanlık portalı muafiyet tescil başvurusu',
      'Yıllık faaliyet raporu teslimi',
    ],
  ),

  // --- 3 Adet Yurtdışı ---
  ProgramModel(
    id: 'p7',
    title: 'Erasmus for Young Entrepreneurs',
    provider: 'Avrupa Birliği Komisyonu',
    category: 'Yurtdışı',
    status: ProgramStatus.open,
    deadline: DateTime(2026, 12, 1),
    description:
        'Yeni girişimcilerin Avrupa’daki deneyimli bir girişimciyle 1-6 ay boyunca çalışmasını finanse eden değişim programı.',
    applicationSteps: [
      'Özgeçmiş ve motivasyon mektubunun sisteme yüklenmesi',
      'İş planının yerel aracı kuruluş tarafından onaylanması',
      'Avrupalı ev sahibi girişimci ile eşleşme ve seyahat bursu',
    ],
  ),
  ProgramModel(
    id: 'p8',
    title: 'Plug and Play Silicon Valley Hızlandırma',
    provider: 'Plug and Play Tech Center',
    category: 'Yurtdışı',
    status: ProgramStatus.upcoming,
    deadline: DateTime(2027, 1, 20),
    description:
        'Silikon Vadisi ekosisteminde global kurumsal ortaklarla pilot proje (PoC) ve yatırımcı erişim programı.',
    applicationSteps: [
      'Online başvuru formu ve ürün demo bağlantısı',
      'Global sektör liderleri ile ön mülakat',
      'Sunnyvale, CA merkezinde 12 haftalık hızlandırma',
    ],
  ),
  ProgramModel(
    id: 'p9',
    title: 'London Tech Bridge Global İvme Programı',
    provider: 'UK Department for Business & Trade',
    category: 'Yurtdışı',
    status: ProgramStatus.closed,
    deadline: DateTime(2026, 10, 1),
    description:
        'İngiltere pazarında şirket kurulumu ve Avrupa fintech ağına entegrasyonu hızlandıran köprü programı.',
    applicationSteps: [
      'İngiltere pazarı büyüme strateji dokümanı teslimi',
      'Panel mülakatı',
      'Londra fintech haftası resmi daveti',
    ],
  ),

  // --- 3 Adet Özel Fon ---
  ProgramModel(
    id: 'p10',
    title: 'QNB EYG - Geleceğin Girişimcileri Destek Fonu',
    provider: 'QNB Enpara & EYG',
    category: 'Özel Fon',
    status: ProgramStatus.open,
    deadline: DateTime(2026, 11, 25),
    description:
        'Ödeme sistemleri, yapay zeka ve mikro KOBİ SaaS çözümleri üreten girişimlere sıfır hisse ile nakit tohum desteği.',
    applicationSteps: [
      'Girişim tanıtım videosu ve gelir modeli sunumu',
      'Banka inovasyon ekipleri ile teknik entegrasyon mülakatı',
      'Demo Day sahne sunumu ve ödül dağıtımı',
    ],
  ),
  ProgramModel(
    id: 'p11',
    title: 'Sabancı ARF - Almost Ready to Fly Girişim Fonu',
    provider: 'Sabancı Topluluğu',
    category: 'Özel Fon',
    status: ProgramStatus.upcoming,
    deadline: DateTime(2026, 12, 10),
    description:
        'Sürdürülebilirlik, ileri malzeme ve dijital teknolojilerde PoC aşamasındaki girişimlere 150.000 USD tohum fonu.',
    applicationSteps: [
      'ARF portalı üzerinden tek sayfa özet (One-pager) gönderimi',
      'Bootcamp ve tasarım odaklı düşünme atölyeleri',
      'Yatırım komitesi nihai kararı',
    ],
  ),
  ProgramModel(
    id: 'p12',
    title: 'İş Bankası 100. Yıl Girişimcilik Fonu',
    provider: 'Türkiye İş Bankası',
    category: 'Özel Fon',
    status: ProgramStatus.closed,
    deadline: DateTime(2026, 9, 30),
    description:
        'Türkiye Yüzyılında teknoloji ihracatı hedefleyen ölçeklenme evresindeki girişimlere stratejik fon katkısı.',
    applicationSteps: [
      'Girişim sermayesi yatırım fonu portalı başvurusu',
      'Finansal ve hukuki durum tespiti (Due Diligence)',
      'Fon ortaklık protokolü',
    ],
  ),

  // --- 3 Adet Kuluçka ---
  ProgramModel(
    id: 'p13',
    title: 'İTÜ Çekirdek Erken Aşama Kuluçka Merkezi',
    provider: 'İTÜ ARI Teknokent',
    category: 'Kuluçka',
    status: ProgramStatus.open,
    deadline: DateTime(2026, 11, 10),
    description:
        'Dünyanın en iyi üniversite kuluçka merkezlerinden biri; laboratuvar, ofis, mentorluk ve Big Bang sahnesi imkanı.',
    applicationSteps: [
      'itücekirdek.com üzerinden form doldurma',
      'Ön kuluçka kabul paneli sunumu',
      'Eğitim ve mentorluk kampları',
      'Big Bang Startup Challenge sahneye çıkış',
    ],
  ),
  ProgramModel(
    id: 'p14',
    title: 'ODTÜ TEKNOKENT Ön Kuluçka & Hızlandırma',
    provider: 'ODTÜ TEKNOKENT',
    category: 'Kuluçka',
    status: ProgramStatus.upcoming,
    deadline: DateTime(2027, 1, 15),
    description:
        'Derin teknoloji, savunma sanayii ve medikal yazılım projelerine akademik mentorluk ve prototipleme altyapısı.',
    applicationSteps: [
      'Akademik danışman ve ekip bilgisiyle başvuru',
      'Teknoloji hazırlık seviyesi (TRL) değerlendirmesi',
      'Prototip geliştirme atölyesi tahsisi',
    ],
  ),
  ProgramModel(
    id: 'p15',
    title: 'Bilkent Cyberpark BİGG Cyber Kuluçka Programı',
    provider: 'Bilkent CYBERPARK',
    category: 'Kuluçka',
    status: ProgramStatus.closed,
    deadline: DateTime(2026, 8, 15),
    description:
        'Bilişim, telekom ve siber güvenlik odaklı girişimcilere Ankara merkezli hızlandırma ve laboratuvar desteği.',
    applicationSteps: [
      'Cyberpark portalı başvuru formu',
      'Hızlandırıcı eğitim kampları',
      'TÜBİTAK nihai jüri yönlendirmesi',
    ],
  ),
];
