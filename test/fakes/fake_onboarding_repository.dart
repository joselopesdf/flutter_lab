import 'package:flutter_lab/data/repositories/onboarding_repository.dart';

/// Fake em memória para os testes do ViewModel e dos ecrãs.
///
/// Não toca em disco nem em plugins: o teste controla o estado inicial
/// e pode verificar o que foi gravado.
class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({this.seen = false});

  bool seen;

  @override
  Future<bool> hasSeenOnboarding() async => seen;

  @override
  Future<void> markOnboardingSeen() async => seen = true;
}
