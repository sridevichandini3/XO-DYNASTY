import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/auth_providers.dart';
import '../domain/app_user.dart';

/// First screen shown. Restores a saved guest session automatically;
/// otherwise offers a single "Continue as Guest" action.
class AuthGateScreen extends ConsumerWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppUser?> authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<AppUser?>>(authControllerProvider,
        (AsyncValue<AppUser?>? previous, AsyncValue<AppUser?> next) {
      next.whenData((AppUser? user) {
        if (user != null) context.go('/home');
      });
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'XO Dynasty',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15, end: 0),
              const SizedBox(height: 12),
              Text(
                'Tic Tac Toe, reimagined.',
                style: Theme.of(context).textTheme.bodyLarge,
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
              const SizedBox(height: 40),
              authState.when(
                data: (_) => const SizedBox.shrink(),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Icon(Icons.error_outline),
              ),
              FilledButton.icon(
                onPressed: authState.isLoading
                    ? null
                    : () => ref
                        .read(authControllerProvider.notifier)
                        .continueAsGuest(),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Continue as Guest'),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
