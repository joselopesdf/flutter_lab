# MAPA_SINTOMAS.md — Flutter Lab

> O meu manual de diagnóstico. Cada linha nasce de um problema que **vi e resolvi** no Lab.
> Método: **sintoma → hipótese → medir/provar → corrigir → provar com números → registar aqui.**

| O cliente/eu vejo… | Causa provável | Como provo | Solução | Módulo |
|---|---|---|---|---|
| "Não instala por cima", `INSTALL_FAILED_VERSION_DOWNGRADE` | versionCode novo ≤ instalado (ex.: `--build-number` não fica no pubspec) | `adb install -r`; ver `version:` no `pubspec.yaml` | versionCode sempre a subir; pubspec é a fonte da verdade | M0.5 Etapa 2 |
| "Não atualiza", `INSTALL_FAILED_UPDATE_INCOMPATIBLE: signatures do not match` | APK assinado com outra chave (debug vs upload key, outra máquina) | `keytool -printcert -jarfile app.apk` (comparar Owner/SHA256) | Uma app = uma chave; desinstalar uma vez (perde dados locais) | M0.5 Etapa 4a |
| CI falha no `analyze` mas no PC passa | Versão do Flutter diferente (CI usa a mais recente) | Comparar `flutter --version` local com o log da CI | Fixar `flutter-version` no workflow (reprodutibilidade) | M0.5 Etapa 3 |
| Build release: `Keystore was tampered with, or password was incorrect` | Password errada no `key.properties` (placeholder, espaço) | Verificar o ficheiro sem expor a password | Corrigir a password; nunca deixar placeholders | M0.5 Etapa 4a |
| CI: `Tag number over 30 is not supported` | Keystore descodificada vazia/estragada — secret com nome errado chega **vazio, sem erro** | Log do step: secret vazio vs `***`; `base64 length`, `sha256sum` | Nome do secret igual ao do workflow (copiar e colar) | M0.5 Etapa 4a |
| Testei a correção e "não mudou nada" | O build falhou e estou a testar o ficheiro antigo | Data do ficheiro; procurar `√ Built` no output | Confirmar sucesso do build antes de testar | M0.5 Etapa 4a |
| Upload no Firebase: package name não corresponde | App registada no Firebase com nome errado | Comparar com o `applicationId` do Gradle | Remover e registar a app de novo (o nome não se edita) | M0.5 Etapa 4b |
| Logo fora do sítio (canto superior esquerdo) | `Stack` com constraints soltas encolhe para o filho maior | Widget Inspector: ver constraints do Stack | `StackFit.expand`, `SizedBox.expand` ou `Center` | M0.5 Etapa 1 / M3 |

## Por preencher ao longo do curso (exemplos esperados)
- "Perco o que estava a fazer quando recebo uma chamada" → process death (M13a).
- "A app está lenta no meu telemóvel fraco" → medir em profile no DevTools antes de escolher a solução (M15).
- "As notificações não chegam com a app fechada" → handler em background/terminated, otimização de bateria (M13d/e).
- "A tarefa em segundo plano parou na Xiaomi" → restrições do fabricante (M13e).
