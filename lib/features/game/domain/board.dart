import 'package:equatable/equatable.dart';

import 'cell_mark.dart';

/// Result of evaluating a board's terminal state.
class BoardOutcome extends Equatable {
  const BoardOutcome({
    required this.isTerminal,
    this.winner,
    this.winningLine,
    this.isDraw = false,
  });

  const BoardOutcome.ongoing()
      : isTerminal = false,
        winner = null,
        winningLine = null,
        isDraw = false;

  final bool isTerminal;
  final CellMark? winner;
  final List<int>? winningLine;
  final bool isDraw;

  @override
  List<Object?> get props =>
      <Object?>[isTerminal, winner, winningLine, isDraw];
}

/// Immutable NxN board plus the pure logic to place moves and detect
/// wins/draws. Deliberately game-mode agnostic (size is a parameter) so
/// 4x4/5x5 variants can reuse this exact engine.
class Board extends Equatable {
  Board({required this.size, List<CellMark>? cells})
      : cells = cells ?? List<CellMark>.filled(size * size, CellMark.empty);

  final int size;
  final List<CellMark> cells;

  int get cellCount => size * size;

  CellMark markAt(int row, int col) => cells[row * size + col];

  bool get isFull => cells.every((CellMark c) => !c.isEmpty);

  /// Returns a new board with [mark] placed at the given index, or throws
  /// a [StateError] if the cell is already occupied — callers (the game
  /// notifier) are expected to check [canPlaceAt] first, but this guard
  /// protects the engine from ever producing an invalid board state.
  Board placeMark(int index, CellMark mark) {
    if (!canPlaceAt(index)) {
      throw StateError('Cell $index is already occupied.');
    }
    final List<CellMark> next = List<CellMark>.of(cells);
    next[index] = mark;
    return Board(size: size, cells: next);
  }

  bool canPlaceAt(int index) =>
      index >= 0 && index < cellCount && cells[index].isEmpty;

  /// All winning lines for this board size: every row, column, and the
  /// two diagonals. Requires at least 3 in a row to win, matching the
  /// classic rule set for 3x3 (and generalizing for larger boards).
  List<List<int>> get _winningLines {
    final List<List<int>> lines = <List<int>>[];

    for (int row = 0; row < size; row++) {
      lines.add(List<int>.generate(size, (int col) => row * size + col));
    }
    for (int col = 0; col < size; col++) {
      lines.add(List<int>.generate(size, (int row) => row * size + col));
    }
    lines.add(List<int>.generate(size, (int i) => i * size + i));
    lines.add(List<int>.generate(size, (int i) => i * size + (size - 1 - i)));

    return lines;
  }

  BoardOutcome evaluate() {
    for (final List<int> line in _winningLines) {
      final CellMark first = cells[line.first];
      if (first.isEmpty) continue;
      final bool allMatch =
          line.every((int index) => cells[index] == first);
      if (allMatch) {
        return BoardOutcome(
          isTerminal: true,
          winner: first,
          winningLine: line,
        );
      }
    }

    if (isFull) {
      return const BoardOutcome(isTerminal: true, isDraw: true);
    }

    return const BoardOutcome.ongoing();
  }

  List<int> get emptyIndices => <int>[
        for (int i = 0; i < cellCount; i++)
          if (cells[i].isEmpty) i,
      ];

  @override
  List<Object?> get props => <Object?>[size, cells];
}
