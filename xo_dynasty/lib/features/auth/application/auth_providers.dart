import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local_guest_auth_repository.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

/// Swap this single provider to change how the app authenticates
/// (e.g. override with a Firebase-backed [AuthRepository] in tests
/// or in a future release) without touching [AuthController] or any UI.
final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((Ref ref) => LocalGuestAuthRepository());

final AsyncNotifierProvider<AuthController, AppUser?> authControllerProvider =
    AsyncNotifierProvider<AuthController, AppUser?>(AuthController.new);

class AuthController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() {
    return ref.read(authRepositoryProvider).restoreSession();
  }

  Future<void> continueAsGuest({String? displayName}) async {
    state = const AsyncLoading<AppUser?>();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signInAsGuest(
            displayName: displayName,
          ),
    );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData<AppUser?>(null);
  }
}
