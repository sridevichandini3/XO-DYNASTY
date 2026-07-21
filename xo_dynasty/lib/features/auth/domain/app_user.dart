import 'package:equatable/equatable.dart';

/// A minimal, transport-agnostic representation of a signed-in player.
///
/// Kept independent of any specific auth provider (Firebase, guest, or
/// otherwise) so the rest of the app never depends on a vendor SDK type.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.displayName,
    required this.isGuest,
  });

  final String id;
  final String displayName;
  final bool isGuest;

  @override
  List<Object?> get props => <Object?>[id, displayName, isGuest];
}
