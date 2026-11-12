# STUDY_PLAN.md — Flutter Lab

> Plano de estudos do Lab: ir de A a Z em Flutter, com foco em apps **rápidas, fluidas e personalizadas**, e em estar pronto para **produção** (deploy, manutenção, debugging).
>
> Construído a partir de: documentação oficial (Flutter Learning Pathway, App Architecture Guide), Code With Andrea (Andrea Bizzotto, GDE: arquitetura Riverpod, project structure, Flutter in Production) e Tadas Petra (GDE: bootcamp Flutter com constraints, DevTools, keys, TDD e deploy nas duas lojas).

---

## 0. Regras do Lab

1. **Cada experiência segue o ciclo:** hipótese → implementação → medição → conclusão. Fica registada em `EXERCISES.md`; o que aprendeste vai para `TECHNICAL_NOTES.md`.
2. **Performance só se mede em modo profile** (`flutter run --profile`) e num dispositivo real. Números do modo debug não contam.
3. **Primeiro com o SDK, depois com o pacote.** Só adicionas um pacote depois de sentires o problema que ele resolve, e justificas a escolha.
4. **Arquitetura onde ajuda, não onde atrapalha.** Experiências de rendering, layout e animação ficam num único ficheiro. Funcionalidades com dados usam MVVM.
5. **Um conceito só fica "dominado" com três provas:** implementaste sem ajuda, depuraste um bug nele e explicaste-o por palavras tuas.
6. **Documentação oficial primeiro.** Tutoriais e cursos complementam, não substituem.
7. **Lab ≈ 80% do tempo, Scout App ≈ 20%.** No Scout App só entra o que já foi provado no Lab.

### Formato de cada experiência

```
## EXP-000 — Título
Módulo: M3 Layout
Hipótese:
Montagem:
Medição (ferramenta + modo):
Resultado:
Conclusão:
Aplicação no Scout App:
Estado: em curso | concluído | repetir
```

---

## 1. Arquitetura do Lab

O Lab é **uma única app Flutter em formato catálogo**: cada experiência é um ecrã. A própria app vai para produção (App Distribution → testes internos na Play Store → TestFlight).

- **Funcionalidades com dados:** MVVM oficial do Flutter.
  - Camada UI: View + ViewModel (`Notifier`/`AsyncNotifier` do Riverpod).
  - Camada Data: Repository (fonte de verdade) + Service (acesso cru: Firestore, HTTP, armazenamento local).
  - Domain (use cases) **opcional**: só quando há lógica de negócio partilhada.
- **Comparação obrigatória (M8):** a arquitetura de 4 camadas do Andrea (presentation / application / domain / data) contra o MVVM oficial. O que é diferente? O que é só nomenclatura? Quando é que a camada *application* justifica existir?

```
lib/
├── main.dart
├── app/            # router, tema, bootstrap, providers globais
├── core/           # design system, widgets partilhados, utils
├── data/
│   ├── services/
│   └── repositories/
├── domain/
│   └── models/
└── experiments/    # catálogo do Lab, um módulo por pasta
```

*(Proposta inicial. Será ajustada depois de analisar o projeto real.)*

---

## 2. Módulos

Ordem recomendada. Cada módulo tem uma **porta de saída**: só avanças quando a cumprires.

### M0 — Ambiente e ferramentas *(2–3 dias)*
- `flutter doctor`, canais, versões, FVM (Flutter Version Manager): o que é e quando usar.
- VS Code / Android Studio: debugger, breakpoints, hot reload vs hot restart vs full restart.
- Emulador vs dispositivo real; modos debug / profile / release (JIT vs AOT).
- Git: commits pequenos, branches, `.gitignore` de Flutter.
- **Porta de saída:** explicas porque é que o modo debug é mais lento e o que muda em release.

### M0.5 — Sprint 0: Walking skeleton de produção *(1–2 semanas, em paralelo com M1)*
> A partir daqui, **cada prática termina num deploy**.
- **Etapa 1 · Splash nativo:** Android 12+ SplashScreen API vs `launch_background` (Android <12), `flutter_native_splash`; splash nativo vs ecrã Flutter de arranque; medir o tempo até ao primeiro frame. Sem delays falsos.
- **Etapa 2 · Versionamento:** `version: x.y.z+build` no `pubspec.yaml`, `versionName` vs `versionCode`, build number automático na CI.
- **Etapa 3 · CI:** GitHub Actions em cada PR: `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test`.
- **Etapa 4 · CD:** merge na `main` → AAB assinado (segredos no GitHub Secrets) → Firebase App Distribution e/ou Play Console *internal testing*.
- **Etapa 5 · Atualização obrigatória e opcional:**
  - (a) Mecanismo próprio: Remote Config com `min_supported_version` / `latest_version`, comparar versões, diálogo bloqueante vs dispensável. Funciona em qualquer canal e em iOS.
  - (b) Google Play In-App Updates: *immediate* (obrigatória) vs *flexible* (opcional). Só funciona com a app instalada pelo Google Play (testes internos servem; APK instalado à mão não).
- **Atenção à Play Store:** contas pessoais criadas depois de 13/11/2023 precisam de um teste fechado com ≥12 testers durante 14 dias seguidos antes de pedirem acesso a produção. O *internal testing* não conta para esse requisito.
- **Porta de saída:** abres um PR, a CI fica verde, fazes merge, e o telemóvel recebe a nova versão com o diálogo de atualização correto, sem passos manuais.

### M1 — Dart a fundo *(2–3 semanas)*
- Tipos, null safety, `final`/`const`/`late`, funções, closures.
- Coleções (List/Map/Set, iteráveis, operadores *spread* e *collection-if/for*).
- OOP: classes, construtores (named, factory, const, redirecting), encapsulamento, herança, `abstract`, `interface`, `base`, `final`, `sealed`.
- Mixins, extensions, generics, enums avançados.
- Records e patterns, `switch` exaustivo com `sealed`.
- Exceções e o Result pattern.
- **Event loop:** microtask queue vs event queue, `Future`, `async/await`, `Stream` (single vs broadcast), `StreamController`.
- Isolates (`Isolate.run`), quando compensam.
- Imutabilidade, igualdade (`==`/`hashCode`), `copyWith`.
- **Experiências:** EXP ordem do event loop; EXP JSON pesado na main thread vs `Isolate.run` (medir frames perdidos).
- **Porta de saída:** prevês a ordem de execução de código assíncrono sem correr e modelas um domínio com `sealed` + patterns.

### M2 — Como o Flutter funciona por dentro *(1–2 semanas)*
- Widget → Element → RenderObject: quem é imutável, quem persiste, quem pinta.
- O que acontece num `setState`: dirty elements, `build`, reconciliação (`canUpdate`: runtimeType + key).
- Pipeline de frame: build → layout → paint → composição → raster (UI thread vs raster thread), vsync.
- `StatelessWidget` vs `StatefulWidget`, ciclo de vida do `State` (`initState`, `didChangeDependencies`, `didUpdateWidget`, `dispose`).
- `BuildContext`, `InheritedWidget`, `mounted` depois de `await`.
- **Keys**: `ValueKey`, `ObjectKey`, `UniqueKey`, `GlobalKey`. Bugs reais sem elas.
- **Experiências:** EXP contador de rebuilds; EXP lista reordenável sem e com keys; EXP `const` vs não-`const` medido.
- **Recursos:** vídeos "How Flutter Works" do pathway oficial; série *Decoding Flutter*.
- **Porta de saída:** desenhas no papel as três árvores para um ecrã simples e explicas o que é reconstruído e o que é reutilizado.

### M3 — Layout, constraints, responsividade e adaptabilidade *(2 semanas)*
- "Constraints go down. Sizes go up. Parent sets position." (página oficial *Understanding constraints*).
- Bounded vs unbounded, `Expanded`/`Flexible`, `Stack`/`Positioned`, `Wrap`, slivers.
- Erros clássicos: overflow, unbounded height, `RenderFlex` (ler e resolver sem tentativa-erro).
- `LayoutBuilder`, `MediaQuery` (e `MediaQuery.sizeOf`), breakpoints, orientação, teclado e `viewInsets`, `SafeArea`.
- **Responsivo** (tamanho) vs **adaptativo** (plataforma e input: toque, rato, teclado; Material vs Cupertino).
- Texto: escalamento de fonte (acessibilidade), overflow, `FittedBox`.
- **Experiências:** EXP o mesmo ecrã em telemóvel, tablet e paisagem; EXP 10 erros de layout para diagnosticar.
- **Porta de saída:** resolves qualquer erro de layout lendo a mensagem de erro e as constraints no Widget Inspector.

### M4 — UI personalizada e design system *(2–3 semanas)*
- `ThemeData`, `ColorScheme`, `TextTheme`, **`ThemeExtension`** para tokens próprios, modo claro/escuro.
- Componentes próprios reutilizáveis (botões, cards, inputs) com API limpa.
- `CustomPainter`, `ClipPath`, gradientes, sombras, `BackdropFilter` (e o custo de cada um).
- `CustomMultiChildLayout`, `Flow`; introdução a `RenderBox` próprio (avançado).
- Fontes e assets, ícones personalizados, imagens SVG/raster.
- **Experiências:** EXP implementar um ecrã "do Figma" pixel-perfect; EXP custo de `BackdropFilter`/`saveLayer` no DevTools.
- **Porta de saída:** pegas num design que não cabe nos widgets Material e implementa-lo com componentes do teu design system.

### M5 — Input, formulários e interatividade *(1–2 semanas)*
- `TextField`/`TextFormField`, `TextEditingController`, `FocusNode` e foco, `Form` e validação, máscaras e formatters.
- Teclado: tipos, ações, fechar teclado, scroll para o campo ativo.
- Gestos: `GestureDetector`, `InkWell`, arenas de gestos, `Dismissible`, drag.
- Acessibilidade: `Semantics`, áreas tocáveis, contraste, leitor de ecrã (TalkBack/VoiceOver).
- **Porta de saída:** formulário de criação de perfil de jogador com validação, foco correto e acessível.

### M6 — Navegação e routing *(1 semana)*
- `Navigator` imperativo, depois `go_router`: rotas aninhadas, `ShellRoute`/`StatefulShellRoute` (tabs que guardam estado), parâmetros, redirects (auth guard).
- Deep links (ligação com M13).
- **Experiência:** EXP tabs com scroll e estado preservados ao trocar.
- **Porta de saída:** navegação com bottom tabs, sub-rotas e guard de autenticação.

### M7 — Estado: de `setState` a Riverpod *(3 semanas)*
- O mesmo ecrã com `setState` → `ValueNotifier`/`ChangeNotifier` → `InheritedWidget` → Riverpod. Comparar rebuilds e manutenção.
- Riverpod (versão 3.x): `Provider`, `Notifier`, `AsyncNotifier`, `StreamNotifier`, families, `autoDispose` e keepAlive, `ref.watch`/`read`/`listen`, `select`, `AsyncValue`, overrides, `ProviderContainer` em testes.
- Com e sem code generation: decidir conscientemente.
- **Estado de UI efémero vs estado da app.** Onde vive cada um?
- **Guardar estado:** `PageStorageKey`, `AutomaticKeepAliveClientMixin`, `IndexedStack`, restauração de estado (`RestorationMixin`).
- **Porta de saída:** explicas porque escolheste cada tipo de provider, e não há rebuilds desnecessários (provado no DevTools).

### M8 — Arquitetura e engenharia *(2 semanas, e contínuo)*
- MVVM oficial: View, ViewModel, Repository, Service; Command pattern.
- Comparação com a arquitetura de 4 camadas do Andrea e com Clean Architecture "completa".
- Feature-first vs layer-first; DTOs, models, mappers; Result pattern; injeção de dependências com Riverpod.
- SOLID aplicado (sem dogma), refactoring, dívida técnica.
- **Porta de saída:** funcionalidade completa em MVVM com Repository testado por fakes.

### M9 — Rede, dados e offline *(2–3 semanas)*
- HTTP com `http`, depois `dio` (interceptors, timeouts, retry); erros de rede reais.
- Serialização à mão → `json_serializable`/`freezed`.
- Autenticação com tokens: JWT, refresh token, armazenamento seguro.
- Paginação, cache, offline-first, sincronização, `connectivity_plus`.
- Persistência local: `shared_preferences` vs SQLite (`sqflite`/`drift`).
- **Porta de saída:** lista paginada com cache que funciona offline e recupera de falhas.

### M10 — Firebase *(3 semanas)*
- Setup com FlutterFire CLI; ambientes (dev/prod) em projetos Firebase separados.
- Auth (email, Google), Firestore (modelação, queries, índices, listeners vs get, paginação), Storage (uploads com progresso), Security Rules + Emulator Suite, Cloud Functions.
- **Custos:** leituras, listeners abertos, downloads. Como uma query mal feita custa dinheiro.
- **Porta de saída:** CRUD com regras de segurança testadas no emulador.

### M11 — Listas, media e vídeo *(2 semanas)*
- `ListView.builder` / `GridView` / slivers, `itemExtent`, lazy loading, scroll infinito.
- Imagens: `cacheWidth/cacheHeight`, `cached_network_image`, precache, memória de imagens.
- **Vídeo:** `video_player`; inicializar só o visível (±1), pausar fora do ecrã, `dispose` correto; feed estilo Reels.
- Câmara e galeria (`image_picker`, `camera`), compressão.
- **Experiências:** EXP feed com 500 itens e imagens (antes/depois); EXP 20 vídeos: todos os controllers vs janela deslizante (memória).
- **Porta de saída:** feed de vídeos fluido (sem jank em profile) e sem fugas de memória.

### M12 — Animações e motion *(2 semanas)*
- Implícitas (`AnimatedContainer`, `TweenAnimationBuilder`), explícitas (`AnimationController`, `Tween`, `Curves`), `AnimatedBuilder`, Hero, transições de página próprias, animações escalonadas, física (spring).
- Custo de animar layout vs animar transform/opacity.
- **Porta de saída:** microinterações polidas a 60/120 fps medidos.

### M13 — Nativo e plataforma *(3 semanas)*
- `AppLifecycleState`, permissões (`permission_handler`), sistema de ficheiros (`path_provider`), `url_launcher`.
- Notificações locais e push (FCM), deep links/App Links (`app_links`).
- Geolocalização e mapas.
- **Platform Channels** (MethodChannel/EventChannel) com Kotlin; Pigeon; noções de Swift.
- Background processing: limites reais no Android e no iOS.
- Segurança mobile: segredos, ofuscação, armazenamento seguro, certificate pinning (noções).
- **Porta de saída:** funcionalidade nativa simples feita por ti em Kotlin via Platform Channel.

### M14 — Testes *(contínuo, com bloco dedicado de 2 semanas)*
- Unit (ViewModels, Repositories, lógica pura), widget tests, integration tests, golden tests.
- Mocks vs fakes (`mocktail`), testar providers com `ProviderContainer` e overrides, testes assíncronos e de streams, `fake_cloud_firestore` / Emulator.
- TDD em pequenas funcionalidades; o que **não** vale a pena testar.
- **Porta de saída:** cada funcionalidade nova vem com testes que falham se o comportamento partir.

### M15 — Performance e debugging com DevTools *(2 semanas, e contínuo)*
- Performance view (frames UI/raster, jank), CPU profiler, Memory (heap snapshots, leaks, diff), Network, Widget Inspector, "Track widget rebuilds", app size.
- Shader jank, `RepaintBoundary`, `saveLayer`, opacidade/clip caros.
- Startup time, tamanho do APK/AAB, `--analyze-size`.
- Ler stack traces, `debugPrint`, logging estruturado, depurar em release.
- **Porta de saída:** pegas numa app lenta (feita por mim de propósito), encontras 3 problemas com o DevTools e provas a melhoria com números.

### M16 — Produção: build, deploy e manutenção *(3 semanas)*
- Flavors (dev/staging/prod) e configuração por ambiente; ícone e splash.
- Android: signing, AAB, `minSdk`/`targetSdk`, ProGuard/R8, Play Console (testes internos → fechado → produção).
- iOS: certificados, provisioning, TestFlight (requer Mac ou CI macOS).
- CI/CD: GitHub Actions (analyze + test + build), Codemagic como alternativa; versionamento semântico e `buildNumber`.
- Crashlytics, Analytics, monitorização, feature flags/Remote Config, atualizações forçadas.
- **Porta de saída:** a app do Lab publicada em testes internos com CI a correr testes em cada PR e crash reporting ativo.

---

## 3. Coisas importantes que não se podem esquecer

- [ ] `dispose` de controllers, streams, subscriptions e listeners.
- [ ] `mounted` antes de usar `context` depois de `await`.
- [ ] Nunca medir performance em modo debug.
- [ ] Acessibilidade e escalamento de texto desde o início.
- [ ] Tratar loading, erro e vazio em todos os ecrãs.
- [ ] Segredos fora do código e do Git.
- [ ] Security Rules antes de dados reais.
- [ ] `flutter analyze` sem avisos e testes verdes antes de cada commit.
- [ ] Ler a mensagem de erro inteira antes de pesquisar.
- [ ] Atualizar dependências com cuidado (changelogs, breaking changes).

---

## 4. Ritmo semanal (≈3 h/dia)

| Bloco | Tempo | O quê |
|---|---|---|
| 1. Aquecimento | 10 min | 3 perguntas sobre a sessão anterior, sem consulta |
| 2. Conceito | 30 min | Explicação + documentação oficial |
| 3. Prática | 1h–1h30 | Eu escrevo e corro; o mentor explica e dá pistas |
| 4. Teste | 20 min | `analyze` + `test` + revisão de PR + perguntas de "porquê" |
| 5. Registo | 10 min | `PROGRESS.md`, `EXERCISES.md`, `TECHNICAL_NOTES.md` |
| 6. Commit | 5 min | Commit feito por mim, com Conventional Commits |

- **1 dia por semana:** "dia de produção" (deploy, CI, ou aplicar algo provado no Scout App).
- **A cada 2–3 semanas:** avaliação sem respostas prévias.

---

## 5. Porta para o Scout App a sério (passar a 50/50)

- [ ] Explica e reduz rebuilds com prova no DevTools (M2, M15).
- [ ] Ecrã MVVM + Riverpod + Firestore + testes do ViewModel (M7, M8, M10, M14).
- [ ] Resolve erros de constraints sem tentativa-erro (M3).
- [ ] App do Lab em testes internos com CI (M16).

---

## 6. Recursos

**Oficiais (sempre primeiro)**
- Flutter Learning Pathway: https://docs.flutter.dev/learn/pathway
- Dart tutorial: https://dart.dev/learn/tutorial
- Understanding constraints: https://docs.flutter.dev/ui/layout/constraints
- App architecture guide: https://docs.flutter.dev/app-architecture/guide
- Architecture case study (Compass app): https://docs.flutter.dev/app-architecture/case-study
- Riverpod: https://riverpod.dev
- Vídeos: Decoding Flutter, Widget of the Week (canal `flutterdev` no YouTube)

**Comunidade (GDEs)**
- Code With Andrea, arquitetura com Riverpod: https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/
- Code With Andrea, estrutura de projeto: https://codewithandrea.com/articles/flutter-project-structure
- Code With Andrea, curso *Flutter in Production* (monitorização, analytics, CI/CD): https://codewithandrea.com/courses/flutter-in-production/
- Tadas Petra, Flutter Bootcamp (ZTM: constraints, DevTools, keys, TDD, deploy Play Store e App Store): https://zerotomastery.io/courses/flutter-bootcamp/
