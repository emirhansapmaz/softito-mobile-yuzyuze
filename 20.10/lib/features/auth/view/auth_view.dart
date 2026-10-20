import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/starfield_background.dart';
import '../../shell/view/shell_view.dart';
import '../controller/auth_controller.dart';
import '../data/mock_auth_data.dart';
import '../models/user_role.dart';
import '../widget/auth_text_field.dart';
import '../widget/login_button.dart';
import '../widget/role_selection_card.dart';

/// Yörünge Platformu - Kimlik Doğrulama ve Rol Seçim Ekranı.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late final AuthController _authController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController.instance;
    _emailController = TextEditingController(text: kMockEntrepreneur.email);
    _passwordController = TextEditingController(text: 'yorunge123');

    _authController.selectedRoleNotifier.addListener(_syncEmailWithRole);
  }

  void _syncEmailWithRole() {
    final role = _authController.selectedRole;
    if (role == null) return;
    final user = kMockUsers.firstWhere(
      (u) => u.role == role,
      orElse: () => kMockEntrepreneur,
    );
    _emailController.text = user.email;
  }

  @override
  void dispose() {
    _authController.selectedRoleNotifier.removeListener(_syncEmailWithRole);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final success = await _authController.login(
      _emailController.text,
      _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const ShellView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingAllLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _AuthHeader(),
                AppSpacing.gapH24,
                _RoleSelectionSection(controller: _authController),
                AppSpacing.gapH24,
                _AuthFormSection(
                  authController: _authController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onLogin: _handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Başlık ve Logo Bölümü
class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Column(
      children: [
        _buildLogo(colors),
        AppSpacing.gapH12,
        Text(
          'YÖRÜNGE',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: colors.textPrimary,
          ),
        ),
        AppSpacing.gapH4,
        Text(
          'Girişimcilik ve Yatırım Ekosistemi',
          style: textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLogo(dynamic colors) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.glow.withValues(alpha: 0.5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Icon(Icons.rocket_launch_rounded, size: 32, color: colors.primary),
    );
  }
}

/// Rol Seçimi Bölümü
class _RoleSelectionSection extends StatelessWidget {
  final AuthController controller;

  const _RoleSelectionSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.spaceColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giriş Yapmak İstediğiniz Rolü Seçin',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        AppSpacing.gapH12,
        ValueListenableBuilder<UserRole?>(
          valueListenable: controller.selectedRoleNotifier,
          builder: (context, selectedRole, _) {
            return Column(
              children: UserRole.values.map((role) {
                return RoleSelectionCard(
                  role: role,
                  isSelected: selectedRole == role,
                  onTap: () => controller.selectRole(role),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Giriş Formu ve Buton Bölümü
class _AuthFormSection extends StatelessWidget {
  final AuthController authController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  const _AuthFormSection({
    required this.authController,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: emailController,
          label: 'E-Posta Adresi',
          hint: 'ornek@yorunge.io',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        AppSpacing.gapH16,
        AuthTextField(
          controller: passwordController,
          label: 'Şifre',
          hint: '••••••••',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
        ),
        AppSpacing.gapH24,
        ValueListenableBuilder<bool>(
          valueListenable: authController.isLoadingNotifier,
          builder: (context, isLoading, _) {
            return LoginButton(
              onPressed: onLogin,
              isLoading: isLoading,
              title: 'Yörüngeye Bağlan',
            );
          },
        ),
      ],
    );
  }
}
