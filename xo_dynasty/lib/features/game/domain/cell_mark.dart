/// What occupies a single board cell.
enum CellMark {
  empty,
  x,
  o;

  CellMark get opponent {
    switch (this) {
      case CellMark.x:
        return CellMark.o;
      case CellMark.o:
        return CellMark.x;
      case CellMark.empty:
        return CellMark.empty;
    }
  }

  bool get isEmpty => this == CellMark.empty;
}

/// Difficulty presets for the AI opponent, mapped to how much the
/// minimax search is deliberately weakened (see GameAi).
enum AiDifficulty {
  easy,
  medium,
  hard,
  expert,
  impossible,
}
