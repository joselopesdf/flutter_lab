import '../services/local_storage_service.dart';
import 'onboarding_repository.dart';

/// Implementação que guarda o estado do onboarding no dispositivo.
class OnboardingRepositoryLocal implements OnboardingRepository {
  OnboardingRepositoryLocal(this._storage);

  final LocalStorageService _storage;

  /// A chave é um detalhe de persistência: só este ficheiro a conhece.
  static const _seenKey = 'onboarding_seen';

  @override
  Future<bool> hasSeenOnboarding() async {
    // Regra do domínio: "nunca gravado" significa "ainda não viu".
    return await _storage.getBool(_seenKey) ?? false;
  }

  @override
  Future<void> markOnboardingSeen() => _storage.setBool(_seenKey, true);
}
