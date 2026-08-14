import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/application/settings_controller.dart';

final initialOnboardingCompletedProvider = Provider<bool>((ref) => false);

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, bool>(OnboardingController.new);

class OnboardingController extends Notifier<bool> {
  @override
  bool build() => ref.watch(initialOnboardingCompletedProvider);

  Future<void> complete() async {
    if (state) {
      return;
    }
    await ref.read(preferencesRepositoryProvider).saveOnboardingCompleted();
    state = true;
  }
}
