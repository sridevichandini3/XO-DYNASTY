/// Static, app-wide constant values.
///
/// Keeping these in one place avoids magic numbers/strings scattered
/// across features and makes future game modes easy to add.
abstract final class AppConstants {
  static const String appName = 'XO Dynasty';

  /// Shared preferences keys.
  static const String prefsGuestIdKey = 'xo_dynasty_guest_id';
  static const String prefsDisplayNameKey = 'xo_dynasty_display_name';
  static const String prefsThemeModeKey = 'xo_dynasty_theme_mode';

  /// Board configuration for the classic 3x3 mode. Kept as a constant
  /// (rather than hard-coded in widgets) so future modes (4x4, 5x5,
  /// Connect Four) can reuse the same engine with a different size.
  static const int classicBoardSize = 3;

  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 700);
}
