import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

/// A fully working, offline auth implementation.
///
/// This is intentionally real (not a stub): it persists a stable guest
/// id and display name on-device so a returning player keeps their
/// local profile and stats between launches. There is no network or
/// cloud dependency here, which is why no Firebase project config is
/// required to run this app today.
///
/// To add real accounts later, implement [AuthRepository] with
/// firebase_auth and swap the provider override in
/// `lib/core/di/auth_providers.dart` — nothing else needs to change.
class LocalGuestAuthRepository implements AuthRepository {
  static const List<String> _adjectives = <String>[
    'Swift',
    'Golden',
    'Shadow',
    'Crimson',
    'Silent',
    'Cosmic',
    'Iron',
    'Blazing',
  ];
  static const List<String> _nouns = <String>[
    'Fox',
    'Falcon',
    'Wolf',
    'Tiger',
    'Phoenix',
    'Raven',
    'Dragon',
    'Panther',
  ];

  @override
  Future<AppUser?> restoreSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString(AppConstants.prefsGuestIdKey);
    final String? name = prefs.getString(AppConstants.prefsDisplayNameKey);
    if (id == null || name == null) return null;
    return AppUser(id: id, displayName: name, isGuest: true);
  }

  @override
  Future<AppUser> signInAsGuest({String? displayName = ''}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString(AppConstants.prefsGuestIdKey) ??
        _generateId();
    final String name = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : (prefs.getString(AppConstants.prefsDisplayNameKey) ??
            _generateDisplayName());

    await prefs.setString(AppConstants.prefsGuestIdKey, id);
    await prefs.setString(AppConstants.prefsDisplayNameKey, name);

    return AppUser(id: id, displayName: name, isGuest: true);
  }

  @override
  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefsGuestIdKey);
    await prefs.remove(AppConstants.prefsDisplayNameKey);
  }

  String _generateId() {
    final Random random = Random.secure();
    return List<int>.generate(16, (_) => random.nextInt(256))
        .map((int b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  String _generateDisplayName() {
    final Random random = Random();
    final String adjective = _adjectives[random.nextInt(_adjectives.length)];
    final String noun = _nouns[random.nextInt(_nouns.length)];
    final int suffix = random.nextInt(9000) + 1000;
    return '$adjective$noun$suffix';
  }
}
