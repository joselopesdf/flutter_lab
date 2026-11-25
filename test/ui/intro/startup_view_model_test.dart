import 'package:flutter_lab/data/repositories/onboarding_repository.dart';
import 'package:flutter_lab/domain/models/startup_destination.dart';
import 'package:flutter_lab/ui/intro/startup_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_onboarding_repository.dart';

/// Simula uma falha do armazenamento.
class ThrowingOnboardingRepository implements OnboardingRepository {
  @override
  Future<bool> hasSeenOnboarding() async =>
      throw Exception('disco indisponível');

  @override
  Future<void> markOnboardingSeen() async {}
}

/// Cria um container isolado com o repository substituído.
ProviderContainer createContainer(OnboardingRepository repository) {
  final container = ProviderContainer(
    overrides: [onboardingRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('onboarding por ver → destino onboarding', () async {
    final container = createContainer(FakeOnboardingRepository());

    final destination = await container.read(startupViewModelProvider.future);

    expect(destination, StartupDestination.onboarding);
  });

  test('onboarding já visto → destino home', () async {
    final container = createContainer(FakeOnboardingRepository(seen: true));

    final destination = await container.read(startupViewModelProvider.future);

    expect(destination, StartupDestination.home);
  });

  test('erro a ler o estado → destino onboarding (caminho seguro)', () async {
    final container = createContainer(ThrowingOnboardingRepository());

    final destination = await container.read(startupViewModelProvider.future);

    expect(destination, StartupDestination.onboarding);
  });
}
