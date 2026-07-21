import 'app_user.dart';

/// Abstraction over "however the player is authenticated".
///
/// Swap [LocalGuestAuthRepository] for a Firebase-backed implementation
/// later without touching any UI or provider code — that's the point of
/// the repository pattern here.
abstract interface class AuthRepository {
  Future<AppUser?> restoreSession();

  /// Signs in (or restores) a guest profile. If [displayName] is null or
  /// empty, a friendly random name is generated for a first-time guest.
  Future<AppUser> signInAsGuest({String? displayName});

  Future<void> signOut();
}
