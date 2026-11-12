# EXERCISES.md — Exercícios e experiências

> Cada entrada segue o formato do `STUDY_PLAN.md`. A solução nunca é escrita aqui antes de eu tentar.

## Índice

| ID | Título | Módulo | Nível | Estado |
|---|---|---|---|---|
| EX-001 | Identidade da app: nome, ícone e splash (Android + iOS) | M0.5 | 2 · Intermédio | em curso |

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
