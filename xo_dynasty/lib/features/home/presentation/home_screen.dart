import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../../game/application/match_controller.dart';
import '../../game/domain/cell_mark.dart';
import '../../game/domain/match_state.dart';

/// Home hub — where the player picks a match type. Kept intentionally
/// scoped to what actually works today (offline PvP + AI at five
/// difficulties); other modes are easy to add as their own routes
/// once there's a real backend to support them.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppUser?> authState = ref.watch(authControllerProvider);
    final String? name = authState.value?.displayName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('XO Dynasty'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            if (name != null)
              Text(
                'Welcome back, $name',
                style: Theme.of(context).textTheme.titleMedium,
              ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 20),
            Text('Play offline', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _ModeCard(
              title: 'Local 2-Player',
              subtitle: 'Pass the device — first to a line wins.',
              icon: Icons.people_alt_rounded,
              onTap: () => context.push(
                '/game',
                extra: const MatchConfig(opponentType: OpponentType.human),
              ),
            ),
            const SizedBox(height: 12),
            Text('Play vs AI', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final AiDifficulty difficulty in AiDifficulty.values) ...<Widget>[
              _ModeCard(
                title: _difficultyLabel(difficulty),
                subtitle: _difficultyDescription(difficulty),
                icon: Icons.smart_toy_rounded,
                onTap: () => context.push(
                  '/game',
                  extra: MatchConfig(
                    opponentType: OpponentType.ai,
                    aiDifficulty: difficulty,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  String _difficultyLabel(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return 'Easy';
      case AiDifficulty.medium:
        return 'Medium';
      case AiDifficulty.hard:
        return 'Hard';
      case AiDifficulty.expert:
        return 'Expert';
      case AiDifficulty.impossible:
        return 'Impossible';
    }
  }

  String _difficultyDescription(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return 'Makes frequent mistakes — great for learning.';
      case AiDifficulty.medium:
        return 'Plays reasonably but is still beatable.';
      case AiDifficulty.hard:
        return 'Rarely makes mistakes.';
      case AiDifficulty.expert:
        return 'Near-perfect play.';
      case AiDifficulty.impossible:
        return 'Full-depth minimax. At best, you can draw.';
    }
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Icon(icon,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).slideX(begin: 0.05, end: 0);
  }
}
