import '../models/user_model.dart';
import '../models/user_role.dart';

/// Sabit Girişimci Kullanıcısı
const UserModel kMockEntrepreneur = UserModel(
  id: 'u_girisimci',
  name: 'Arda Yılmaz',
  email: 'girisimci@yorunge.com',
  role: UserRole.entrepreneur,
  avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
);

/// Sabit Mentor Kullanıcısı
const UserModel kMockMentor = UserModel(
  id: 'u_mentor',
  name: 'Dr. Selin Aksoy',
  email: 'mentor@yorunge.com',
  role: UserRole.mentor,
  avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
);

/// Sabit Yatırımcı Kullanıcısı
const UserModel kMockInvestor = UserModel(
  id: 'u_yatirimci',
  name: 'Kaan Demir',
  email: 'yatirimci@yorunge.com',
  role: UserRole.investor,
  avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200',
);

/// Giriş testleri ve doğrulama için 3 farklı roldeki sabit mock kullanıcılar
const List<UserModel> kMockUsers = [
  kMockEntrepreneur,
  kMockMentor,
  kMockInvestor,
];

