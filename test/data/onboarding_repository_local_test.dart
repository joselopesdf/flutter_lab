import 'package:flutter_lab/data/repositories/onboarding_repository_local.dart';
import 'package:flutter_lab/data/services/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Substitui o service real por um mapa em memória.
///
/// `implements` usa a interface implícita da classe concreta:
/// em Dart, qualquer classe pode ser implementada.
class FakeLocalStorageService implements LocalStorageService {
  final values = <String, bool>{};

  @override
  Future<bool?> getBool(String key) async => values[key];

  @override
  Future<void> setBool(String key, bool value) async => values[key] = value;
}

void main() {
  late FakeLocalStorageService storage;
  late OnboardingRepositoryLocal repository;

  setUp(() {
    storage = FakeLocalStorageService();
    repository = OnboardingRepositoryLocal(storage);
  });

  test('sem nada gravado, o onboarding não foi visto', () async {
    expect(await repository.hasSeenOnboarding(), isFalse);
  });

  test('depois de markOnboardingSeen, o onboarding foi visto', () async {
    await repository.markOnboardingSeen();

    expect(await repository.hasSeenOnboarding(), isTrue);
  });

  test('markOnboardingSeen grava true no armazenamento', () async {
    await repository.markOnboardingSeen();

    expect(storage.values.values, [true]);
  });
}
