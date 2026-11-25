import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/startup_destination.dart';
import 'startup_view_model.dart';

/// Ecrã de intro: continua o splash nativo e anima o logo.
///
/// Navega só quando as duas condições se cumprem:
/// 1. a animação terminou;
/// 2. o StartupViewModel já tem o destino.

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({
    super.key,
    required this.destinationBuilder,
    this.onLogoReady,
  });

  /// Constrói o ecrã de cada destino. A intro sabe *quando* sair;
  /// quem a cria (o `main.dart`) sabe *para onde*.
  final Widget Function(StartupDestination destination) destinationBuilder;

  /// Chamado quando o logo já está em memória e pronto a desenhar.
  /// O `main.dart` usa-o para libertar o primeiro frame (ver passo 7).
  final VoidCallback? onLogoReady;

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen>
    with SingleTickerProviderStateMixin {
  // Valores copiados do splash nativo: têm de ser iguais, senão há "salto".
  static const _background = Color(0xFF0D1B2A);
  static const _logo = AssetImage('assets/splash/logo.png');
  static const _logoSize = 288.0; // 288 dp no Android e 288 pt no iOS.

  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleOpacity;

  bool _started = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // O logo cresce 8% nos primeiros 60% da animação.
    _logoScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // O título aparece do 40% ao 100%: sobrepõe-se ao fim do crescimento.
    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _maybeNavigate();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precisa de `context`, por isso não pode ir no initState.
    // O flag garante que só corre uma vez.
    if (_started) return;
    _started = true;

    // Descodifica o logo antes de o mostrar: sem isto, os primeiros frames
    // saem só com o fundo e o logo "pisca".
    precacheImage(_logo, context).then((_) {
      if (!mounted) return;
      widget.onLogoReady?.call();
      _controller.forward();
    });
  }


  void _maybeNavigate() {
    if (_navigated || !_controller.isCompleted) return;

    final destination = ref.read(startupViewModelProvider).value;
    if (destination == null) return; // A inicialização ainda não terminou.

    _navigated = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => widget.destinationBuilder(destination),
      ),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `listen` e não `watch`: nada no ecrã depende do destino, por isso não
    // queremos rebuilds. Também é isto que arranca o build() do ViewModel,
    // em paralelo com a animação.
    ref.listen(startupViewModelProvider, (_, next) {
      if (next.hasValue) _maybeNavigate();
    });

    return Scaffold(
      backgroundColor: _background,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _logoScale,
              child: const Image(
                image: _logo,
                width: _logoSize,
                height: _logoSize,
              ),
            ),
            // O título fica por baixo do logo sem o empurrar: o logo continua
            // exatamente no centro, como no splash nativo.
            Transform.translate(
              offset: const Offset(0, _logoSize / 2 + 16),
              child: FadeTransition(
                opacity: _titleOpacity,
                child: const Text(
                  'Flutter Lab',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
