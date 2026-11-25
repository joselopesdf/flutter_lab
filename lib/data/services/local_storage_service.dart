import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Acesso cru ao armazenamento chave-valor do dispositivo.
///
/// É o único ficheiro da app que conhece o `shared_preferences`.
/// Não sabe nada do domínio (onboarding, tema...): só guarda e lê valores
/// por chave. O significado de cada chave é responsabilidade do repository.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferencesAsync _prefs;

  /// Devolve `null` se a chave nunca foi gravada.
  Future<bool?> getBool(String key) => _prefs.getBool(key);

  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);
}

/// Dá a instância do service a quem precisar (o repository).
///
/// Nos testes pode ser substituído com `overrides`, sem tocar em código de
/// produção.
final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(SharedPreferencesAsync()),
);
