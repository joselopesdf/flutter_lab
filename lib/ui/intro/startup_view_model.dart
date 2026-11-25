import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/onboarding_repository.dart';
import '../../domain/models/startup_destination.dart';

/// ViewModel do arranque.
///
/// Corre a inicialização da app e decide o destino. A IntroScreen começa a
/// animação ao mesmo tempo que este `build()` corre: os dois trabalham em
/// paralelo e a View só navega quando ambos terminarem.
class StartupViewModel extends AsyncNotifier<StartupDestination> {
  @override
  Future<StartupDestination> build() async {
    final repository = ref.watch(onboardingRepositoryProvider);

    try {
      final seen = await repository.hasSeenOnboarding();
      return seen ? StartupDestination.home : StartupDestination.onboarding;
    } catch (error, stackTrace) {
      // Política de erro (decisão 1 do plano): se não conseguimos ler o
      // estado, mostramos o onboarding. É o caminho seguro: no pior caso o
      // utilizador vê-o mais uma vez. Mais tarde isto vai para o Crashlytics.
      debugPrint('Startup falhou: $error\n$stackTrace');
      return StartupDestination.onboarding;
    }
  }
}

final startupViewModelProvider =
    AsyncNotifierProvider<StartupViewModel, StartupDestination>(
      StartupViewModel.new,
    );
