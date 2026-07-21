import 'dart:math';

import 'board.dart';
import 'cell_mark.dart';

/// A real minimax-with-alpha-beta-pruning AI opponent.
///
/// [AiDifficulty.impossible] always plays the game-theoretic optimal
/// move (full-depth search — cannot lose at 3x3). Weaker difficulties
/// don't "cheat" or get bonus information; instead they deliberately
/// pick a sub-optimal move some percentage of the time, which is the
/// standard, honest way to make a perfect-information game like
/// Tic Tac Toe feel beatable without the AI making illegal or
/// instant/inhuman moves.
class GameAi {
  GameAi({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const Map<AiDifficulty, double> _randomMoveChance =
      <AiDifficulty, double>{
    AiDifficulty.easy: 0.75,
    AiDifficulty.medium: 0.45,
    AiDifficulty.hard: 0.15,
    AiDifficulty.expert: 0.05,
    AiDifficulty.impossible: 0.0,
  };

  /// Returns the index the AI chooses to play as [aiMark] on [board].
  int chooseMove({
    required Board board,
    required CellMark aiMark,
    required AiDifficulty difficulty,
  }) {
    final List<int> empties = board.emptyIndices;
    if (empties.isEmpty) {
      throw StateError('chooseMove called on a full board.');
    }
    if (empties.length == 1) {
      return empties.first;
    }

    final double chance = _randomMoveChance[difficulty] ?? 0.0;
    if (chance > 0 && _random.nextDouble() < chance) {
      return empties[_random.nextInt(empties.length)];
    }

    return _bestMove(board: board, aiMark: aiMark);
  }

  int _bestMove({required Board board, required CellMark aiMark}) {
    int? bestIndex;
    int bestScore = -1 << 30;

    for (final int index in board.emptyIndices) {
      final Board next = board.placeMark(index, aiMark);
      final int score = _minimax(
        board: next,
        depth: 1,
        isMaximizing: false,
        aiMark: aiMark,
        alpha: -1 << 30,
        beta: 1 << 30,
      );
      if (score > bestScore) {
        bestScore = score;
        bestIndex = index;
      }
    }

    return bestIndex!;
  }

  int _minimax({
    required Board board,
    required int depth,
    required bool isMaximizing,
    required CellMark aiMark,
    required int alpha,
    required int beta,
  }) {
    final BoardOutcome outcome = board.evaluate();
    if (outcome.isTerminal) {
      return _score(outcome, aiMark, depth);
    }

    final CellMark turn = isMaximizing ? aiMark : aiMark.opponent;

    if (isMaximizing) {
      int best = -1 << 30;
      for (final int index in board.emptyIndices) {
        final Board next = board.placeMark(index, turn);
        final int score = _minimax(
          board: next,
          depth: depth + 1,
          isMaximizing: false,
          aiMark: aiMark,
          alpha: alpha,
          beta: beta,
        );
        best = max(best, score);
        alpha = max(alpha, best);
        if (beta <= alpha) break;
      }
      return best;
    } else {
      int best = 1 << 30;
      for (final int index in board.emptyIndices) {
        final Board next = board.placeMark(index, turn);
        final int score = _minimax(
          board: next,
          depth: depth + 1,
          isMaximizing: true,
          aiMark: aiMark,
          alpha: alpha,
          beta: beta,
        );
        best = min(best, score);
        beta = min(beta, best);
        if (beta <= alpha) break;
      }
      return best;
    }
  }

  /// Prefers faster wins and slower losses by factoring in search depth.
  int _score(BoardOutcome outcome, CellMark aiMark, int depth) {
    if (outcome.isDraw) return 0;
    if (outcome.winner == aiMark) return 10 - depth;
    return depth - 10;
  }
}
