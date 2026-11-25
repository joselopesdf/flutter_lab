/// Para onde a app deve ir quando termina o arranque.
///
/// É o resultado do StartupViewModel: a View não decide o destino,
/// limita-se a navegar para o que o ViewModel lhe devolve.
enum StartupDestination {
  /// O utilizador ainda não viu o onboarding.
  onboarding,

  /// O onboarding já foi visto: vai direto para o ecrã inicial.
  home,
}
