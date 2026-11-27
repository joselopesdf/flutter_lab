# STUDY_PLAN.md — Flutter Lab

> Plano de estudos do Lab: ir de A a Z em Flutter, com foco em apps **rápidas, fluidas e personalizadas**, e em estar pronto para **produção** (deploy, manutenção, debugging).
>
> **Objetivo final (definido em 2026-11-27):** sair daqui um dev Flutter completo, capaz de fazer **qualquer tipo de app** (incluindo processos em segundo plano e integração nativa), **segura, estável e rápida**, de **diagnosticar bugs depressa** e de trabalhar em qualquer empresa do mundo. A longo prazo: caminho para **Google Developer Expert** (como Andrea Bizzotto, Tadas Petra e Jacob Moura).
>
> **Ferramenta contínua:** `MAPA_SINTOMAS.md` — sintoma do cliente → causa provável → como provar → solução → módulo. Preenchido ao longo de todo o curso.
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
- `adb` essencial: `devices`, `install`, `logcat` (filtrar por app), `shell pm`, opções de programador ("Don't keep activities", limite de processos em segundo plano).
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
- **Motores de renderização:** Impeller (padrão atual) vs Skia; porque o Impeller elimina o *shader compilation jank*; como confirmar qual está ativo.
- Arquitetura em camadas: framework (Dart) → engine (C++) → embedder (Android/iOS); onde vive cada coisa.
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
- **Internacionalização (i18n/l10n):** `flutter_localizations`, ficheiros ARB, `gen-l10n`, plurais, datas/moedas (`intl`), RTL. Português e inglês no Lab.
- **Migração para `material_ui` / `cupertino_ui`** (desacoplamento do Material no Flutter ≥3.47) quando o SDK for atualizado.
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

### M13 — Nativo, plataforma e segundo plano *(5–6 semanas)*
> Objetivo: integrar **qualquer** recurso do Android/iOS com o Flutter e fazer trabalho que **sobrevive** à app fechada.

**13a · Ciclo de vida e morte do processo**
- `AppLifecycleState` (resumed, inactive, hidden, paused, detached) e `AppLifecycleListener`.
- **Process death:** o Android mata a app em segundo plano; o estado em memória (Riverpod incluído) desaparece. Persistir e restaurar (rascunhos em disco, `RestorationMixin`, rotas restauráveis).
- Testar com "Don't keep activities" e `adb shell am kill`.
- **Experiência:** EXP formulário que sobrevive a uma chamada + morte do processo.

**13b · Integração nativa (Flutter ↔ Kotlin/Swift)**
- Arquitetura dos Platform Channels: threads (main/platform thread), codecs, serialização.
- `MethodChannel` (pedido/resposta), `EventChannel` (streams nativas → Dart), `BasicMessageChannel`.
- **Pigeon** (canais com tipos seguros, gerados); FFI (`dart:ffi`) para C/C++ (noções).
- Kotlin essencial para dev Flutter: Activity, Context, Intents, permissões, coroutines (noções); Swift essencial (noções).
- Criar um **plugin** próprio (federado: Android + iOS), publicável.
- **Experiências:** EXP bateria/sensor via MethodChannel; EXP stream de um sensor via EventChannel.

**13c · Permissões e recursos do dispositivo**
- `permission_handler`: pedir, negar, "negado para sempre", abrir definições; permissões no `AndroidManifest.xml` e `Info.plist`.
- Ficheiros (`path_provider`), `url_launcher`, partilha.
- Geolocalização (primeiro plano e segundo plano) e mapas.
- Biometria (`local_auth`), câmara, Bluetooth LE, NFC, sensores (noções e um caso prático).

**13d · Notificações e deep links**
- Notificações locais (canais Android, agendadas, ações, permissão do Android 13+).
- FCM: foreground, background e **terminated**; handlers *headless*; dados vs notificação.
- Deep links / App Links / Universal Links (`app_links`), abrir o ecrã certo a partir de uma notificação.

**13e · Trabalho em segundo plano** *(o bloco mais importante)*
- **WorkManager** (`workmanager`): tarefas únicas e periódicas, com condições (Wi-Fi, a carregar, bateria ok), retries e backoff.
- **Foreground services:** tarefas longas com notificação visível (GPS a gravar um treino, áudio, upload grande); tipos de foreground service exigidos pelo Android 14+.
- **Uploads e downloads em segundo plano** que continuam com a app fechada (ex.: `background_downloader`).
- **Isolates em segundo plano:** registar callbacks *top-level*, `@pragma('vm:entry-point')`, comunicar com a UI (`SendPort`/`ReceivePort`, `IsolateNameServer`).
- **Limites reais do Android:** Doze, App Standby Buckets, otimização de bateria, alarmes exatos (`SCHEDULE_EXACT_ALARM`), arranque após reboot (`RECEIVE_BOOT_COMPLETED`), fabricantes que matam apps (Xiaomi, Samsung, Huawei — dontkillmyapp.com).
- **iOS:** `BGTaskScheduler` (app refresh vs processing), background modes, porque o iOS é muito mais restrito.
- Escolher a ferramenta certa: WorkManager vs foreground service vs alarme vs push (tabela de decisão).
- **Porta de saída do bloco:** uma tarefa que **sobrevive** a fechares a app e a reiniciares o telemóvel, com logs que o provam.

**13f · Segurança na integração nativa** (aprofundada no M17)
- Segredos fora da app, armazenamento seguro (Keystore/Keychain via `flutter_secure_storage`), ofuscação.

- **Porta de saída do módulo:** funcionalidade nativa feita por ti em Kotlin via Pigeon/Platform Channel **e** uma tarefa em segundo plano robusta (13e), ambas no Lab e explicadas em inglês.

### M14 — Testes *(contínuo, com bloco dedicado de 2 semanas)*
- Unit (ViewModels, Repositories, lógica pura), widget tests, integration tests, golden tests.
- Mocks vs fakes (`mocktail`), testar providers com `ProviderContainer` e overrides, testes assíncronos e de streams, `fake_cloud_firestore` / Emulator.
- TDD em pequenas funcionalidades; o que **não** vale a pena testar.
- Testes que tocam no nativo (diálogos de permissão, notificações) com **Patrol**; testes em vários dispositivos (Firebase Test Lab, noções).
- **Porta de saída:** cada funcionalidade nova vem com testes que falham se o comportamento partir.

### M15 — Performance e debugging com DevTools *(2 semanas, e contínuo)*
- Performance view (frames UI/raster, jank), CPU profiler, Memory (heap snapshots, leaks, diff), Network, Widget Inspector, "Track widget rebuilds", app size.
- Shader jank, `RepaintBoundary`, `saveLayer`, opacidade/clip caros.
- Startup time, tamanho do APK/AAB, `--analyze-size`.
- Ler stack traces, `debugPrint`, logging estruturado, depurar em release.
- **Telemóveis fracos:** testar num Android de gama baixa, pouca RAM, rede lenta (throttling); memória de imagens; tempo de arranque a frio.
- **Triagem de crashes:** ANRs, crashes nativos no `logcat`, *symbolication* de stack traces ofuscados (`--split-debug-info`), reproduzir um bug reportado por um utilizador.
- **Método de diagnóstico:** sintoma → hipótese → medir → corrigir → provar com números → registar no `MAPA_SINTOMAS.md`.
- **Porta de saída:** pegas numa app lenta (feita por mim de propósito), encontras 3 problemas com o DevTools e provas a melhoria com números.

### M16 — Produção: build, deploy e manutenção *(3 semanas)*
- Flavors (dev/staging/prod) e configuração por ambiente; ícone e splash.
- Android: signing, AAB, `minSdk`/`targetSdk`, ProGuard/R8, Play Console (testes internos → fechado → produção).
- iOS: certificados, provisioning, TestFlight (requer Mac ou CI macOS).
- CI/CD: GitHub Actions (analyze + test + build), Codemagic como alternativa; versionamento semântico e `buildNumber`.
- Crashlytics, Analytics, monitorização, feature flags/Remote Config, atualizações forçadas.
- **Manutenção a longo prazo:** atualizar o SDK do Flutter (FVM), `flutter pub outdated`, ler changelogs e breaking changes, `dart fix`, migrações (ex.: `material_ui`), `targetSdk` anual exigido pela Play.
- **Gestão de chaves e contas:** backup da keystore, Play App Signing, contas no nome do cliente (projetos para bancos/governo).
- **Porta de saída:** a app do Lab publicada em testes internos com CI a correr testes em cada PR e crash reporting ativo.

### M17 — Segurança mobile para bancos e governo *(2–3 semanas)*
- **OWASP MASVS / MASTG:** o que cada categoria exige (armazenamento, criptografia, autenticação, rede, plataforma, código, resiliência).
- Armazenamento seguro (Keystore/Keychain), dados sensíveis em memória, logs sem dados pessoais.
- Rede: HTTPS, **certificate pinning**, proteção contra MITM.
- Autenticação forte: biometria, sessão, refresh tokens, *device binding*.
- Resiliência: ofuscação, deteção de root/jailbreak e emuladores (noções e limites), anti-tamper, `FLAG_SECURE` (bloquear screenshots).
- O cliente nunca é confiável: validação no servidor, App Check (Firebase), idempotência em pagamentos.
- **Porta de saída:** checklist MASVS aplicada ao Lab, com cada ponto provado ou justificado.

### M18 — Pagamentos e monetização *(1–2 semanas)*
- In-App Purchases e subscrições (`in_app_purchase`, RevenueCat), validação no servidor, *entitlements*.
- Pagamentos externos (Stripe e similares) e regras das lojas.
- **Porta de saída:** paywall com subscrição de teste ativa e restaurável.

### M19 — Multiplataforma *(1–2 semanas)*
- Flutter Web (renderizadores, SEO, limites) e desktop (Windows/macOS/Linux): quando faz sentido.
- Código adaptativo por plataforma e por input; plugins com suporte parcial.
- **Porta de saída:** o Lab a correr em web e desktop com layout adaptativo.

### M20 — Expert e comunidade (caminho GDE) *(contínuo)*
- Ler o código-fonte do Flutter; abrir issues bem documentadas; contribuir (docs, testes, um PR pequeno).
- Publicar um pacote no pub.dev (com testes, exemplo, pontuação alta).
- Artigos e talks **em inglês** (e português), mentoria, comunidade (Flutter Cabo Verde / lusófona).
- Trabalhar com IA como engenheiro: `CLAUDE.md`, specs e planos, rever criticamente o código gerado.
- Confirmar os requisitos atuais do programa GDE antes de se candidatar.
- **Porta de saída:** um pacote publicado + 3 artigos técnicos em inglês baseados no Lab.

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
- [ ] Testar process death ("Don't keep activities") em ecrãs com dados do utilizador.
- [ ] Backup da keystore e das passwords fora do PC.
- [ ] Copiar e colar identificadores (package name, nomes de secrets, App IDs) em vez de os escrever à mão.

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
