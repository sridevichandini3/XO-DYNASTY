import 'package:flutter_test/flutter_test.dart';
import 'package:xo_dynasty/features/game/domain/board.dart';
import 'package:xo_dynasty/features/game/domain/cell_mark.dart';
import 'package:xo_dynasty/features/game/domain/game_ai.dart';

void main() {
  group('GameAi', () {
    test('impossible difficulty takes an immediate winning move', () {
      // O to move, can win by playing index 2 (row 0: O _ _ then O O _)
      const List<CellMark> cells = <CellMark>[
        CellMark.o, CellMark.o, CellMark.empty,
        CellMark.x, CellMark.x, CellMark.empty,
        CellMark.empty, CellMark.empty, CellMark.empty,
      ];
      final Board board = Board(size: 3, cells: cells);
      final GameAi ai = GameAi();

      final int move = ai.chooseMove(
        board: board,
        aiMark: CellMark.o,
        difficulty: AiDifficulty.impossible,
      );

      expect(move, 2);
    });

    test('impossible difficulty blocks an opponent about to win', () {
      // X to win at index 2 next; O must block there.
      const List<CellMark> cells = <CellMark>[
        CellMark.x, CellMark.x, CellMark.empty,
        CellMark.o, CellMark.empty, CellMark.empty,
        CellMark.empty, CellMark.empty, CellMark.empty,
      ];
      final Board board = Board(size: 3, cells: cells);
      final GameAi ai = GameAi();

      final int move = ai.chooseMove(
        board: board,
        aiMark: CellMark.o,
        difficulty: AiDifficulty.impossible,
      );

      expect(move, 2);
    });

    test('impossible AI never loses a full self-consistent game vs itself'
        ' playing perfectly for both sides (always ends in a draw)', () {
      final GameAi ai = GameAi();
      Board board = Board(size: 3);
      CellMark turn = CellMark.x;

      while (!board.evaluate().isTerminal) {
        final int move = ai.chooseMove(
          board: board,
          aiMark: turn,
          difficulty: AiDifficulty.impossible,
        );
        board = board.placeMark(move, turn);
        turn = turn.opponent;
      }

      expect(board.evaluate().isDraw, isTrue);
    });

    test('chooseMove returns the only remaining cell when just one is left',
        () {
      final List<CellMark> cells = List<CellMark>.filled(9, CellMark.x)
        ..[8] = CellMark.empty;
      final Board board = Board(size: 3, cells: cells);
      final GameAi ai = GameAi();

      final int move = ai.chooseMove(
        board: board,
        aiMark: CellMark.o,
        difficulty: AiDifficulty.easy,
      );

      expect(move, 8);
    });
  });
}
