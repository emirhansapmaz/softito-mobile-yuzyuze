import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

final currentUserDataProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider).value;
  if (authState == null) return null;
  final authService = ref.watch(authServiceProvider);
  return await authService.getUserData(authState.uid);
});
