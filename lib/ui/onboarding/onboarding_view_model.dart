import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/onboarding_repository.dart';

/// ViewModel do onboarding.
///
/// O estado é `AsyncValue<void>`: não há dados para mostrar, só interessa
/// saber se está a gravar (loading), se gravou (data) ou se falhou (error).
class OnboardingViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Nada para carregar: o ecrã começa logo em `AsyncData(null)`.
  }

  /// Regista que o utilizador concluiu o onboarding.
  Future<void> complete() async {
    state = const AsyncLoading();
    // `guard` apanha exceções e transforma-as em `AsyncError`,
    // em vez de as deixar rebentar na View.
    state = await AsyncValue.guard(
      () => ref.read(onboardingRepositoryProvider).markOnboardingSeen(),
    );
  }
}

final onboardingViewModelProvider =
    AsyncNotifierProvider<OnboardingViewModel, void>(OnboardingViewModel.new);
