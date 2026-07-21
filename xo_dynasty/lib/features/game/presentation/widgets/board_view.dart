import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../domain/board.dart';
import '../../domain/cell_mark.dart';

/// Renders an NxN [Board] as a grid of animated, tappable cells.
///
/// [onCellTap] is only invoked for empty cells; the widget itself has
/// no game logic — it is a pure presentation component driven by
/// [MatchController].
class BoardView extends StatelessWidget {
  const BoardView({
    required this.board,
    required this.onCellTap,
    this.winningLine,
    this.enabled = true,
    super.key,
  });

  final Board board;
  final ValueChanged<int> onCellTap;
  final List<int>? winningLine;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: colors.surfaceContainerHigh,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: board.cellCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: board.size,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (BuildContext context, int index) {
            final CellMark mark = board.cells[index];
            final bool isWinningCell = winningLine?.contains(index) ?? false;
            return _BoardCell(
              mark: mark,
              isWinningCell: isWinningCell,
              onTap: (enabled && mark.isEmpty)
                  ? () => onCellTap(index)
                  : null,
            );
          },
        ),
      ),
    );
  }
}

class _BoardCell extends StatelessWidget {
  const _BoardCell({
    required this.mark,
    required this.isWinningCell,
    required this.onTap,
  });

  final CellMark mark;
  final bool isWinningCell;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    final Color background = isWinningCell
        ? colors.primaryContainer
        : colors.surfaceContainerHighest;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Center(
          child: mark.isEmpty
              ? const SizedBox.shrink()
              : _MarkGlyph(mark: mark)
                  .animate()
                  .scale(
                    begin: const Offset(0.4, 0.4),
                    end: const Offset(1, 1),
                    duration: 220.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: 150.ms),
        ),
      ),
    );
  }
}

class _MarkGlyph extends StatelessWidget {
  const _MarkGlyph({required this.mark});

  final CellMark mark;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color color =
        mark == CellMark.x ? colors.primary : colors.tertiary;

    return Text(
      mark == CellMark.x ? 'X' : 'O',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: color,
      ),
    );
  }
}
