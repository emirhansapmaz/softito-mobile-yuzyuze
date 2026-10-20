import '../models/analiz_model.dart';

/// Boş başlangıç analiz modeli
const AnalizModel kEmptyAnalizData = AnalizModel();

/// Test ve taslak doğrulama amaçlı örnek doldurulmuş analiz verisi
const AnalizModel kMockDraftAnalizData = AnalizModel(
  ideaSummary:
      'Yörünge: Türk girişimcilik ekosistemini yapay zeka destekli yatırımcı ve mentor eşleşmesiyle hızlandıran yeni nesil girişimcilik platformu.',
  teamDetails:
      '2 Kurucu Ortak: 1 Full-stack Mobil Mimar (10+ yıl deneyim), 1 B2B Büyüme & Yatırım İlişkileri Lideri (Eski VC Analisti).',
  traction:
      'İlk 3 haftada 150+ doğrulanmış girişimci ön kaydı, 16 yatırımcı fonu ön mutabakatı ve 3 pilot hızlandırma partnerliği.',
  innovation:
      'Sıfır harici state paketiyle çalışan reaktif durum mimarisi, tescilli hibrit eşleşme algoritması ve anlık telemetri takibi.',
  planTables:
      'Yıllık operasyonel bütçe: 1.2M TL. İlk 12 ayda 50 kurumsal abonelik ile başa baş (break-even) noktasına ulaşılması hedefleniyor.',
  marketAnalysis:
      'Türkiye ve Doğu Avrupa erken aşama girişim pazarı yıllık 450M\$ hacme sahip. Hedef pazar: 4.500+ aktif teknoloji girişimi.',
  brandPositioning:
      'Derin Uzay ve Şafak Fırlatışı metaforu ile girişimcilerin ideadan yörüngeye yükselişini simgeleyen premium marka kimliği.',
  isCompleted: false,
);
