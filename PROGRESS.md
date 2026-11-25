# PROGRESS.md — Evolução no Flutter Lab

> Regra: um conceito só passa a **Dominado** com três provas: (1) implementei sem ajuda, (2) depurei um bug nesse tema, (3) expliquei-o por palavras minhas.

## Estado atual

- **Data de início:** 2026-11-12
- **Projeto:** `C:\Users\josec\Desktop\flutter_lab` (pacote `flutter_lab`; Android `com.joseclaudino.flutter_lab`; iOS `com.joseclaudino.flutterLab`)
- **Flutter / Dart:** 3.32.4 / SDK `^3.8.1`. **Desatualizado**: `flutter upgrade` por fazer.
- **Git:** inicializado (commits de nome, ícone e splash).
- **Módulo atual:** M0.5 Sprint 0: Etapa 3 (CI com GitHub Actions). EX-001 fica `Em estudo` e é revisto no EX-002.
- **Próximo passo:** Aula 3 (CI com GitHub Actions) → depois teste do EX-001 dentro do EX-002. Pendente: corrigir aviso do NDK (`ndkVersion = "27.0.12077973"`).
- **Diagnóstico inicial:** por fazer (perguntas A1–C4)

## Competências

Estados: `Não iniciado` · `Em estudo` · `Praticado` · `Dominado` · `Repetir`

| Módulo | Tema | Estado | Provas (implementei / depurei / expliquei) | Notas |
|---|---|---|---|---|
| M0 | Ambiente, modos debug/profile/release | Não iniciado | ☐ ☐ ☐ | |
| M0.5 | Splash nativo | Em estudo | ☐ ☑ ☐ | Bug do Stack encontrado; teste no EX-002 |
| M0.5 | Versionamento | Praticado | ☑ ☑ ☑ | Teste relâmpago 3/3 (100%). Viu INSTALL_FAILED_VERSION_DOWNGRADE na prática |
| M0.5 | CI (GitHub Actions) | Não iniciado | ☐ ☐ ☐ | |
| M0.5 | CD (App Distribution / Play internal) | Não iniciado | ☐ ☐ ☐ | |
| M0.5 | Update obrigatório/opcional | Não iniciado | ☐ ☐ ☐ | |
| M1 | Dart: null safety, OOP, sealed, patterns | Não iniciado | ☐ ☐ ☐ | |
| M1 | Dart: event loop, Future, Stream, Isolates | Não iniciado | ☐ ☐ ☐ | |
| M2 | Widget / Element / RenderObject, rebuilds, keys | Não iniciado | ☐ ☐ ☐ | |
| M3 | Constraints, responsivo, adaptativo | Não iniciado | ☐ ☐ ☐ | |
| M4 | UI personalizada, design system | Não iniciado | ☐ ☐ ☐ | |
| M5 | Input, formulários, gestos, acessibilidade | Não iniciado | ☐ ☐ ☐ | |
| M6 | Navegação, go_router | Não iniciado | ☐ ☐ ☐ | |
| M7 | Estado, Riverpod | Não iniciado | ☐ ☐ ☐ | |
| M8 | Arquitetura MVVM | Não iniciado | ☐ ☐ ☐ | |
| M9 | Rede, dados, offline | Não iniciado | ☐ ☐ ☐ | |
| M10 | Firebase | Não iniciado | ☐ ☐ ☐ | |
| M11 | Listas, media, vídeo | Não iniciado | ☐ ☐ ☐ | |
| M12 | Animações | Não iniciado | ☐ ☐ ☐ | |
| M13 | Nativo e plataforma | Não iniciado | ☐ ☐ ☐ | |
| M14 | Testes | Não iniciado | ☐ ☐ ☐ | |
| M15 | Performance, DevTools | Não iniciado | ☐ ☐ ☐ | |
| M16 | Produção, deploy, manutenção | Não iniciado | ☐ ☐ ☐ | |

## Dificuldades identificadas

- Explicar por palavras próprias a fronteira entre o splash nativo e o primeiro frame do Flutter (o pacote gerou o nativo; conceitos `deferFirstFrame`/`allowFirstFrame` novos).
- Constraints: um `Stack` dentro do `body` do `Scaffold` recebe constraints soltas e fica do tamanho do maior filho (rever no M3).

## Diário de sessões

### 2026-11-12
- Definido o objetivo: Flutter de A a Z, apps rápidas, fluidas e personalizadas, prontas para produção.
- Definida a arquitetura: MVVM oficial + Riverpod; Lab como app catálogo.
- Definida a estratégia: Lab 80% / Scout App 20%; cada prática termina num deploy.
- Projeto recriado como `flutter_lab` com `--org com.joseclaudino` e `--platforms android,ios`.
- Nome visível do iOS já é "Flutter Lab"; o do Android ainda é `flutter_lab` (EX-001, Passo A).
- Próximo: diagnóstico A1–C4 e EX-001.

### 2026-11-25
- Fluxo das aulas atualizado no `CLAUDE.md` (7 passos, ≥ 80% para avançar).
- EX-001: observado no telemóvel que o splash nativo mostra o ícone só quando a app é aberta pelo launcher (pelo `flutter run`, no Android 12+, aparece só a cor).
- EX-001: encontrado bug de layout: o logo da `IntroScreen` aparecia no canto superior esquerdo (Stack com constraints soltas). Correção em curso.
- EX-001 fica `Em estudo`: conclusões e teste adiados para o EX-002, que trabalha o mesmo fluxo. Avança-se para a Etapa 2 (versionamento).
- Aula 2 (versionamento): builds 1.3.1+7 e 2.0.0+8; experiência de downgrade (2.0.1+1 recusado: o Android compara só o versionCode). Teste relâmpago 3/3 → aprovado. Frase em inglês pendente.
