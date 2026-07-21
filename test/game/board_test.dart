import 'package:flutter_test/flutter_test.dart';
import 'package:xo_dynasty/features/game/domain/board.dart';
import 'package:xo_dynasty/features/game/domain/cell_mark.dart';

void main() {
  group('Board', () {
    test('starts empty and ongoing', () {
      final Board board = Board(size: 3);
      expect(board.emptyIndices.length, 9);
      expect(board.evaluate().isTerminal, isFalse);
    });

    test('detects a row win', () {
      Board board = Board(size: 3);
      board = board.placeMark(0, CellMark.x);
      board = board.placeMark(1, CellMark.x);
      board = board.placeMark(2, CellMark.x);

      final BoardOutcome outcome = board.evaluate();
      expect(outcome.isTerminal, isTrue);
      expect(outcome.winner, CellMark.x);
      expect(outcome.winningLine, <int>[0, 1, 2]);
    });

    test('detects a column win', () {
      Board board = Board(size: 3);
      board = board.placeMark(0, CellMark.o);
      board = board.placeMark(3, CellMark.o);
      board = board.placeMark(6, CellMark.o);

      final BoardOutcome outcome = board.evaluate();
      expect(outcome.winner, CellMark.o);
      expect(outcome.winningLine, <int>[0, 3, 6]);
    });

    test('detects a diagonal win', () {
      Board board = Board(size: 3);
      board = board.placeMark(0, CellMark.x);
      board = board.placeMark(4, CellMark.x);
      board = board.placeMark(8, CellMark.x);

      expect(board.evaluate().winner, CellMark.x);
    });

    test('detects the anti-diagonal win', () {
      Board board = Board(size: 3);
      board = board.placeMark(2, CellMark.o);
      board = board.placeMark(4, CellMark.o);
      board = board.placeMark(6, CellMark.o);

      expect(board.evaluate().winner, CellMark.o);
    });

    test('detects a draw with no winner', () {
      // X O X
      // X O O
      // O X X
      const List<CellMark> cells = <CellMark>[
        CellMark.x, CellMark.o, CellMark.x,
        CellMark.x, CellMark.o, CellMark.o,
        CellMark.o, CellMark.x, CellMark.x,
      ];
      final Board board = Board(size: 3, cells: cells);

      final BoardOutcome outcome = board.evaluate();
      expect(outcome.isDraw, isTrue);
      expect(outcome.winner, isNull);
    });

    test('placeMark throws on an occupied cell', () {
      Board board = Board(size: 3);
      board = board.placeMark(0, CellMark.x);
      expect(() => board.placeMark(0, CellMark.o), throwsStateError);
    });

    test('canPlaceAt is false for occupied or out-of-range cells', () {
      Board board = Board(size: 3);
      board = board.placeMark(0, CellMark.x);
      expect(board.canPlaceAt(0), isFalse);
      expect(board.canPlaceAt(-1), isFalse);
      expect(board.canPlaceAt(9), isFalse);
      expect(board.canPlaceAt(1), isTrue);
    });
  });
}
