import '../models/fikir_durumu_model.dart';

/// Türkiye girişim ekosistemine özel 6 adet örnek fikir durumu ve hukuki süreç profili
const List<FikirDurumuModel> kMockFikirDurumlari = [
  FikirDurumuModel(
    id: 'f1',
    projectName: 'VeriFlow SaaS Analitiği',
    currentStepIndex: 4, // 5. Adım: TÜRKPATENT Marka Tescil
    lawyerName: 'Av. İpek Kaya',
    lawyerContact: 'ipek.kaya@legalorbit.com.tr',
    incomeSupportProgress: 0.75, // %75 tamamlandı
    isApproved: true,
  ),
  FikirDurumuModel(
    id: 'f2',
    projectName: 'MedAI Tanı Asistanı',
    currentStepIndex: 2, // 3. Adım: MERSİS Başvurusu
    lawyerName: 'Av. Canberk Yurt',
    lawyerContact: 'canberk.yurt@yurthukuk.com',
    incomeSupportProgress: 0.40,
    isApproved: true,
  ),
  FikirDurumuModel(
    id: 'f3',
    projectName: 'CarbonZero B2B ESG',
    currentStepIndex: 1, // 2. Adım: Şirket Tipi Belirleme (A.Ş. vs Ltd.)
    lawyerName: 'Av. Zeynep Bilgin',
    lawyerContact: 'zeynep.bilgin@bilginpartners.com',
    incomeSupportProgress: 0.20,
    isApproved: true,
  ),
  FikirDurumuModel(
    id: 'f4',
    projectName: 'PixelMoon Mobil Oyun',
    currentStepIndex: 5, // 6. Adım: Hissedarlar Sözleşmesi (SHA)
    lawyerName: 'Av. Murat Sancak',
    lawyerContact: 'murat.sancak@sancaklegal.com',
    incomeSupportProgress: 1.0, // Tamamlandı
    isApproved: true,
  ),
  FikirDurumuModel(
    id: 'f5',
    projectName: 'EduOrbit Hibrit Eğitim',
    currentStepIndex: 0, // 1. Adım: Avukat Ataması
    lawyerName: 'Av. Elif Eren',
    lawyerContact: 'elif.eren@erenavukatlik.com',
    incomeSupportProgress: 0.10,
    isApproved: true,
  ),
  FikirDurumuModel(
    id: 'f6',
    projectName: 'Kuantum Lojistik Optimizasyonu',
    currentStepIndex: 0,
    lawyerName: 'Atama Bekleniyor',
    lawyerContact: 'destek@yorunge.com.tr',
    incomeSupportProgress: 0.0,
    isApproved: false, // Henüz iş planı onay aşamasında
  ),
];
