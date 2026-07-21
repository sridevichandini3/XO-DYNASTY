# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [0.1.0] - Initial foundation

### Added
- Project scaffold: pubspec, lint config, CI workflow, docs
- Material 3 theme (light/dark) with Google Fonts
- Go Router navigation (auth gate → home → game)
- Guest authentication, persisted on-device via `shared_preferences`
- Core Tic Tac Toe engine: `Board`, win/draw detection for any NxN size
- Minimax + alpha-beta pruning AI with 5 difficulty levels
- Offline local 2-player and player-vs-AI game screen with animations
- Unit tests for board logic and AI; smoke test for app boot
