import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/landing/presentation/landing_screen.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/quiz/presentation/home_screen.dart';
import '../../features/quiz/presentation/quiz_screen.dart';
import '../../features/quiz/presentation/quiz_setup_screen.dart';
import '../../features/quiz/presentation/results_screen.dart';
import '../../features/quiz/presentation/review_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import 'app_paths.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppPaths.landing,
    redirect: (context, state) {
      final onboardingCompleted = ref.read(onboardingControllerProvider);
      final location = state.matchedLocation;

      if (kIsWeb && location == AppPaths.landing) {
        return null;
      }
      if (!onboardingCompleted && location != AppPaths.onboarding) {
        return AppPaths.onboarding;
      }
      if (onboardingCompleted && location == AppPaths.onboarding) {
        return AppPaths.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppPaths.landing,
        builder: (context, state) =>
            kIsWeb ? const LandingScreen() : const HomeScreen(),
      ),
      GoRoute(
        path: AppPaths.webApp,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppPaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/setup/:quizId',
        builder: (context, state) =>
            QuizSetupScreen(quizId: state.pathParameters['quizId']!),
      ),
      GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
      GoRoute(
        path: '/results',
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
