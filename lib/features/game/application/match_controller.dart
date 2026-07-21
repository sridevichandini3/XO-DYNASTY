import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../domain/cell_mark.dart';
import '../domain/game_ai.dart';
import '../domain/match_state.dart';

/// Parameters needed to start a match — passed via `.family` so the
/// widget tree can request "offline vs AI, hard difficulty" etc.
class MatchConfig {
  const MatchConfig({
    required this.opponentType,
    this.aiDifficulty = AiDifficulty.medium,
    this.boardSize = AppConstants.classicBoardSize,
  });

  final OpponentType opponentType;
  final AiDifficulty aiDifficulty;
  final int boardSize;
}

final AutoDisposeNotifierProviderFamily<MatchController, MatchState,
        MatchConfig> matchControllerProvider = NotifierProvider.autoDispose
    .family<MatchController, MatchState, MatchConfig>(MatchController.new);

/// Owns a single match's lifecycle: applying human moves, triggering the
/// AI's reply (with a short human-feeling delay, never an instant move),
/// detecting the outcome, and tracking the session scoreboard so a
/// player can hit "rematch" repeatedly without losing their streak.
class MatchController extends AutoDisposeFamilyNotifier<MatchState,
    MatchConfig> {
  late GameAi _ai;

  @override
  MatchState build(MatchConfig arg) {
    _ai = GameAi();
    return MatchState.initial(
      boardSize: arg.boardSize,
      opponentType: arg.opponentType,
    );
  }

  /// Human (always plays X) taps a cell.
  Future<void> playHumanMove(int index) async {
    if (state.isGameOver || state.isAiThinking) return;
    if (state.currentTurn != CellMark.x) return;
    if (!state.board.canPlaceAt(index)) return;

    _applyMove(index, CellMark.x);

    if (state.isGameOver) return;

    if (arg.opponentType == OpponentType.ai) {
      await _playAiTurn();
    }
  }

  Future<void> _playAiTurn() async {
    state = state.copyWith(isAiThinking: true);

    // A believable "thinking" delay — the AI must never move instantly,
    // per the product requirement that it feel like a real opponent.
    await Future<void>.delayed(const Duration(milliseconds: 550));

    final int move = _ai.chooseMove(
      board: state.board,
      aiMark: CellMark.o,
      difficulty: arg.aiDifficulty,
    );

    state = state.copyWith(isAiThinking: false);
    _applyMove(move, CellMark.o);
  }

  void _applyMove(int index, CellMark mark) {
    final board = state.board.placeMark(index, mark);
    final outcome = board.evaluate();

    int humanScore = state.humanScore;
    int opponentScore = state.opponentScore;
    int draws = state.draws;

    if (outcome.isTerminal) {
      if (outcome.isDraw) {
        draws++;
      } else if (outcome.winner == CellMark.x) {
        humanScore++;
      } else {
        opponentScore++;
      }
    }

    state = state.copyWith(
      board: board,
      currentTurn: mark.opponent,
      outcome: outcome,
      humanScore: humanScore,
      opponentScore: opponentScore,
      draws: draws,
    );
  }

  /// Starts a new round, keeping the running scoreboard.
  void rematch() {
    final MatchState fresh = MatchState.initial(
      boardSize: arg.boardSize,
      opponentType: arg.opponentType,
    );
    state = fresh.copyWith(
      humanScore: state.humanScore,
      opponentScore: state.opponentScore,
      draws: state.draws,
    );
  }
}
