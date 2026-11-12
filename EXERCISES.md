# EXERCISES.md — Exercícios e experiências

> Cada entrada segue o formato do `STUDY_PLAN.md`. A solução nunca é escrita aqui antes de eu tentar.

## Índice

| ID | Título | Módulo | Nível | Estado |
|---|---|---|---|---|
| EX-001 | Identidade da app: nome, ícone e splash (Android + iOS) | M0.5 | 2 · Intermédio | em curso |
| EX-002 | Intro animada sem costura (splash nativo → Flutter) | M0.5 / M12 | 2 · Intermédio | por iniciar |

---

## EX-001 — Identidade da app: nome, ícone e splash (Android + iOS)

**Módulo:** M0.5 Sprint 0, Etapa 1 · **Nível:** 2 · Intermédio

**Objetivo:** perceber os três "nomes" de uma app, como o Android e o iOS guardam o ícone e o splash, e o que acontece entre tocar no ícone e o primeiro frame do Flutter.

**Contexto:** é o primeiro contacto do utilizador com a app. O cliente pede: "o nosso nome, o nosso logo, a nossa cor, e sem ecrã branco", em Android e iOS.

**Requisitos**
1. **Nomes:** o nome visível no telemóvel é "Flutter Lab" em Android (`android:label`) e iOS (`CFBundleDisplayName`). Sabes distinguir o nome do pacote Dart, o `applicationId`/Bundle ID e o nome visível.
2. **Ícone:** ícone próprio; *adaptive icon* em Android (foreground + background); ícone iOS de 1024×1024 sem transparência.
3. **Splash:** cor de fundo e logótipo do Lab; Android 12+ (SplashScreen API) e Android abaixo de 12; iOS (LaunchScreen).
4. Modo claro e modo escuro.
5. Sem ecrã branco nem flash na transição para o primeiro ecrã Flutter, e sem nenhum delay artificial.

**Restrições**
- Fazes um **commit antes de cada passo** (nome → ícone → splash) e estudas o `git diff` de cada um: tens de saber explicar cada ficheiro nativo alterado.
- O nome visível é alterado **à mão** (para conheceres os ficheiros). O ícone e o splash podem ser feitos com `flutter_launcher_icons` e `flutter_native_splash`, que ficam como `dev_dependencies`.
- iOS: sem Mac, a validação é feita pela leitura dos ficheiros e, mais tarde, pela CI com macOS (Etapa 3).

**Critérios de aceitação**
- [ ] Testado num dispositivo real com Android 12+ (e num emulador com Android abaixo de 12, se possível).
- [ ] Tempo até ao primeiro frame medido em modo **profile** e registado.
- [ ] `flutter analyze` sem avisos.
- [ ] Experiência registada abaixo.

**Perguntas de consolidação**
1. Porque é que o `applicationId`/Bundle ID não pode mudar depois de publicar?
2. Porque é que o Android usa várias pastas `mipmap-*`? O que é um *adaptive icon* e qual é a sua zona segura?
3. Porque é que a Apple rejeita um ícone com transparência?
4. Porque é que o Android 12 mudou a forma como os splashes funcionam?
5. Qual é a diferença entre o splash nativo e um ecrã de arranque em Flutter? Quando faria sentido ter os dois?
6. O que são o `windowBackground`, o `LaunchTheme` e o `LaunchScreen.storyboard`?

**Erros comuns:** logo cortado pela máscara do *adaptive icon* ou do splash do Android 12, ícone iOS com canal alfa, flash branco na transição, splash diferente em modo escuro, configurar só uma versão do Android, esquecer o `CFBundleDisplayName`.

**Critérios de avaliação:** cumpre os requisitos, sei explicar cada ficheiro nativo alterado, a medição é real (modo profile), e as respostas às perguntas estão corretas.

### Registo da experiência
```
Hipótese:
Montagem:
Medição (ferramenta + modo):
Resultado:
Conclusão:
Aplicação no Scout App:
Estado:
```

### Revisão (preenchido pelo mentor)
- (por preencher)

---

## EX-002 — Intro animada sem costura (splash nativo → Flutter)

**Módulo:** M0.5 Sprint 0 (Etapa 1, Passo D) + introdução ao M12 Animações · **Nível:** 2 · Intermédio

**Objetivo:** escrever a tua primeira animação explícita e perceber o ciclo de vida de um `StatefulWidget`, aplicando a técnica oficial de reproduzir o splash nativo no primeiro frame Flutter.

**Leitura obrigatória antes de escrever código**
- Introduction to animations: https://docs.flutter.dev/ui/animations
- Animations tutorial (explícitas): https://docs.flutter.dev/ui/animations/tutorial
- Adding a splash screen (Android): https://docs.flutter.dev/platform-integration/android/splash-screen

**Contexto:** o cliente quer que o logo do splash "ganhe vida" quando a app abre, sem flash nem salto.

**Requisitos**
1. Novo ecrã `IntroScreen` em `lib/` (um ficheiro, sem arquitetura: é uma experiência de UI).
2. O **primeiro frame** é igual ao splash nativo: fundo `#0D1B2A`, `assets/splash/logo.png` centrado.
3. Animação explícita com **um** `AnimationController`: o logo cresce ligeiramente e o texto "Flutter Lab" aparece por baixo com fade.
4. Duração total **≤ 1,5 s**.
5. No fim, navega para o ecrã inicial **sem permitir voltar à intro** com o botão "voltar".
6. O `AnimationController` é libertado corretamente.
7. Sem pacotes de animação (nada de Lottie/Rive). Só o SDK.

**Restrições técnicas**
- Não uses `addListener` + `setState` para redesenhar: usa um widget de animação (`AnimatedBuilder` ou as `*Transition` do SDK).
- O `logo.png` tem de ser declarado nos assets do `pubspec.yaml` (agora o código Dart vai usá-lo).
- Nada de `Future.delayed` para "esperar": a navegação depende do fim da animação.

**Critérios de aceitação**
- [ ] Ao abrir pelo ícone, não há salto visível entre o splash nativo e a intro (grava o ecrã do telemóvel e vê frame a frame).
- [ ] O botão "voltar" no ecrã inicial fecha a app, não volta à intro.
- [ ] `flutter analyze` sem avisos; `flutter test` a passar (o teste antigo do contador tem de ser adaptado ou substituído).
- [ ] Commit `feat: intro animada` feito por ti.

**Testes necessários:** pelo menos um widget test que confirme que, depois de a animação terminar (`pumpAndSettle`), o ecrã inicial está visível.

**Perguntas de consolidação**
1. O que é o `vsync` e porque é que o `AnimationController` precisa dele?
2. Qual é a diferença entre `AnimationController`, `Tween` e `CurvedAnimation`?
3. Porque é que `AnimatedBuilder` é melhor do que `addListener` + `setState`? (Pensa em rebuilds.)
4. O que acontece se não chamares `dispose()` no controller?
5. Qual é a diferença entre animações implícitas e explícitas? Porque é que esta tem de ser explícita?

**Erros comuns:** esquecer o `SingleTickerProviderStateMixin`; criar o controller no `build`; não fazer `dispose`; usar `Navigator.push` (deixa voltar à intro); logo com tamanho diferente do splash nativo (o "salto"); asset não declarado (`Unable to load asset`).

**Critérios de avaliação:** cumpre os requisitos; ciclo de vida correto (`initState`/`dispose`); sem rebuilds desnecessários; consegues explicar cada linha; respostas corretas.

### Registo da experiência
```
Hipótese:
Montagem:
Medição (ferramenta + modo):
Resultado:
Conclusão:
Aplicação no Scout App:
Estado:
```
