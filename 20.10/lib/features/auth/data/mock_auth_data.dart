// Kullanıcı veri modelini içeri alıyoruz
import '../models/user_model.dart';
// Kullanıcı rolü numaralandırmasını içeri alıyoruz
import '../models/user_role.dart';

/// Sabit Girişimci Kullanıcısı (Yatırım arayan kurucu profili)
const UserModel kMockEntrepreneur = UserModel(
  // Kullanıcı kimliği
  id: 'u_girisimci',
  // Kullanıcı tam adı
  name: 'Arda Yılmaz',
  // Kullanıcı e-posta adresi
  email: 'girisimci@yorunge.com',
  // Rolü girişimci
  role: UserRole.entrepreneur,
  // Profil fotoğrafı bağlantısı
  avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
); // kMockEntrepreneur kapanışı

/// Sabit Mentor Kullanıcısı (Girişimcilere yol gösteren uzman profili)
const UserModel kMockMentor = UserModel(
  // Kullanıcı kimliği
  id: 'u_mentor',
  // Kullanıcı tam adı
  name: 'Dr. Selin Aksoy',
  // Kullanıcı e-posta adresi
  email: 'mentor@yorunge.com',
  // Rolü mentor
  role: UserRole.mentor,
  // Profil fotoğrafı bağlantısı
  avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
); // kMockMentor kapanışı

/// Sabit Yatırımcı Kullanıcısı (Girişimlere sermaye sağlayan fon yöneticisi)
const UserModel kMockInvestor = UserModel(
  // Kullanıcı kimliği
  id: 'u_yatirimci',
  // Kullanıcı tam adı
  name: 'Kaan Demir',
  // Kullanıcı e-posta adresi
  email: 'yatirimci@yorunge.com',
  // Rolü yatırımcı
  role: UserRole.investor,
  // Profil fotoğrafı bağlantısı
  avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200',
); // kMockInvestor kapanışı

/// Giriş testleri ve doğrulama için 3 farklı roldeki sabit mock kullanıcılar listesi
const List<UserModel> kMockUsers = [
  // Girişimci
  kMockEntrepreneur,
  // Mentor
  kMockMentor,
  // Yatırımcı
  kMockInvestor,
]; // kMockUsers listesi kapanışı
