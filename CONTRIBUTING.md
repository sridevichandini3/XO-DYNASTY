# Contributing to XO Dynasty

Thanks for considering a contribution.

## Setup

```bash
flutter pub get
flutter test
```

## Guidelines

- Follow the existing feature-first structure: `domain/` (pure Dart,
  no Flutter imports), `data/` (implementations of domain interfaces),
  `application/` (Riverpod state), `presentation/` (widgets/screens).
- New game modes should extend the existing `Board`/`GameAi` engine
  rather than duplicating win-detection logic.
- Run `flutter analyze` and `flutter test` before opening a PR — both
  must be clean.
- Keep PRs scoped to one feature or fix; large multi-feature PRs are
  hard to review and more likely to introduce regressions.

## Commit style

Use clear, imperative commit messages, e.g. `Add draw detection test`
rather than `fixed stuff`.

## Reporting bugs

Open an issue with: steps to reproduce, expected behavior, actual
behavior, and your Flutter/Dart version (`flutter --version`).
