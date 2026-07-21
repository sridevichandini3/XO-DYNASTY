# XO Dynasty

A clean-architecture Tic Tac Toe game built with Flutter and Riverpod.

## Honest scope of this repo

This project is a **real, working offline game** — not a mockup:

- Local 2-player and Player-vs-AI (5 difficulties) 3x3 Tic Tac Toe
- A genuine minimax + alpha-beta-pruning AI (Impossible difficulty
  cannot lose)
- Guest profile persisted on-device (no backend required to play)
- Riverpod state management, Go Router navigation, Material 3 theming
  (light/dark), and `flutter_animate` micro-interactions
- Unit tests for the game engine and AI, plus a basic widget smoke test

It is **not** a live-service game with online multiplayer, a shop,
battle pass, clans, tournaments, or a Firebase backend. Those are
real, substantial systems (server-authoritative networking, payment
validation, moderation tooling, anti-cheat infrastructure) that need
actual backend engineering, not just client-side Dart — building them
honestly is future work, not something to fake with placeholder code.

The architecture is deliberately set up so those systems can be added
later without a rewrite: see [Architecture](#architecture) below.

## Getting started

```bash
flutter pub get
flutter test
flutter run
```

Requires Flutter 3.22+ / Dart 3.4+.

## Architecture

Feature-first, clean-architecture layout:

```
lib/
  core/               # Cross-cutting: theme, router, DI, constants
  features/
    auth/
      domain/         # AppUser entity, AuthRepository interface
      data/           # LocalGuestAuthRepository (on-device, no backend)
      application/    # AuthController (Riverpod AsyncNotifier)
      presentation/   # AuthGateScreen
    game/
      domain/         # Board, CellMark, GameAi (minimax), MatchState
      application/    # MatchController (Riverpod Notifier.family)
      presentation/   # GameScreen, BoardView
    home/
      presentation/   # HomeScreen (mode picker)
```

**Why this shape matters for future growth:**

- `AuthRepository` is an interface. Swapping the on-device guest
  implementation for Firebase Auth later means writing one new class
  and changing one provider override — no UI or controller code changes.
- `Board`/`GameAi` take `size` as a parameter, not a hard-coded `3`.
  A 4x4 or 5x5 mode reuses the exact same engine.
- `MatchController` is a `.family` notifier keyed by `MatchConfig`, so
  adding a new opponent type (e.g. online) means adding a new
  `OpponentType` case and a networked controller — the `GameScreen`
  and `BoardView` don't need to know the difference.

## Testing

```bash
flutter test
```

Covers: all four win-line types, draw detection, invalid-move guards,
AI immediate-win/immediate-block behavior, and a full AI-vs-AI game
proving the Impossible difficulty never loses.

## Roadmap (not yet built)

- Firebase Authentication (email/Google) behind the existing
  `AuthRepository` interface
- Cloud save via Firestore
- Online multiplayer (would need a server-authoritative move-validation
  service — a real backend, not just client code)
- Cosmetics/shop, battle pass (would need Google Play Billing
  integration and server-side purchase verification)

## License

MIT — see [LICENSE](LICENSE).
