import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/local_storage_service.dart';
import 'onboarding_repository_local.dart';

/// Fonte de verdade sobre o onboarding.
///
/// Fala a linguagem do domínio ("já viu o onboarding?"), não a do
/// armazenamento. Quem usa (o ViewModel) depende só desta interface,
/// por isso nos testes pode receber um fake.
abstract interface class OnboardingRepository {
  /// `true` se o utilizador já concluiu o onboarding.
  Future<bool> hasSeenOnboarding();

  /// Regista que o utilizador concluiu o onboarding.
  Future<void> markOnboardingSeen();
}

/// O tipo exposto é a interface; a implementação concreta é um detalhe
/// de ligação que só este provider conhece.
final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepositoryLocal(ref.watch(localStorageServiceProvider)),
);
