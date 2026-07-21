import 'package:equatable/equatable.dart';

import 'board.dart';
import 'cell_mark.dart';

enum OpponentType { human, ai }

/// Full snapshot of an in-progress or finished offline match.
class MatchState extends Equatable {
  const MatchState({
    required this.board,
    required this.currentTurn,
    required this.opponentType,
    required this.outcome,
    required this.humanScore,
    required this.opponentScore,
    required this.draws,
    this.isAiThinking = false,
  });

  factory MatchState.initial({
    required int boardSize,
    required OpponentType opponentType,
  }) {
    return MatchState(
      board: Board(size: boardSize),
      currentTurn: CellMark.x,
      opponentType: opponentType,
      outcome: const BoardOutcome.ongoing(),
      humanScore: 0,
      opponentScore: 0,
      draws: 0,
    );
  }

  final Board board;
  final CellMark currentTurn;
  final OpponentType opponentType;
  final BoardOutcome outcome;
  final int humanScore;
  final int opponentScore;
  final int draws;
  final bool isAiThinking;

  bool get isGameOver => outcome.isTerminal;

  MatchState copyWith({
    Board? board,
    CellMark? currentTurn,
    BoardOutcome? outcome,
    int? humanScore,
    int? opponentScore,
    int? draws,
    bool? isAiThinking,
  }) {
    return MatchState(
      board: board ?? this.board,
      currentTurn: currentTurn ?? this.currentTurn,
      opponentType: opponentType,
      outcome: outcome ?? this.outcome,
      humanScore: humanScore ?? this.humanScore,
      opponentScore: opponentScore ?? this.opponentScore,
      draws: draws ?? this.draws,
      isAiThinking: isAiThinking ?? this.isAiThinking,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        board,
        currentTurn,
        opponentType,
        outcome,
        humanScore,
        opponentScore,
        draws,
        isAiThinking,
      ];
}
