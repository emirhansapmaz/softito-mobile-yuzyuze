import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge_platform/features/auth/controller/auth_controller.dart';
import 'package:yorunge_platform/features/auth/models/user_role.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthController Tests', () {
    late AuthController controller;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      controller = AuthController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state should default to entrepreneur and unauthenticated', () {
      expect(controller.selectedRole, UserRole.entrepreneur);
      expect(controller.currentUser, isNull);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.isLoadingNotifier.value, isFalse);
    });

    test('selectRole should update selectedRoleNotifier', () {
      controller.selectRole(UserRole.mentor);
      expect(controller.selectedRole, UserRole.mentor);

      controller.selectRole(UserRole.investor);
      expect(controller.selectedRole, UserRole.investor);
    });

    test('login with mentor role should assign mentor mock user and persist', () async {
      controller.selectRole(UserRole.mentor);
      final result = await controller.login('mentor@yorunge.com', 'pass123');

      expect(result, isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentUser?.role, UserRole.mentor);
      expect(controller.currentUser?.name, 'Dr. Selin Aksoy');
    });

    test('logout should clear currentUser and stored preferences', () async {
      await controller.login('girisimci@yorunge.com', 'pass123');
      expect(controller.isAuthenticated, isTrue);

      await controller.logout();
      expect(controller.currentUser, isNull);
      expect(controller.isAuthenticated, isFalse);
    });
  });
}
