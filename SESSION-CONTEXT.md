# Contexto de Sesión - OpenCode + OMO

> Copiar y pegar al inicio de cada nueva sesión para continuidad.

## Estado actual del sistema

- **Repo:** `~/git/opencode-omo-sota` (persistente, no en /tmp)
- **Config activa:** `~/.config/opencode/oh-my-openagent.json`
- **Auth:** Solo OpenCode Go conectado. Zen desconectado por defecto.
- **Telemetría:** Desactivada (`OMO_SEND_ANONYMOUS_TELEMETRY=0` en `~/.bashrc`)
- **Alias:** `repos` → `cd ~/git`
- **Push funciona:** Token de GitHub configurado en remote del repo

## Objetivo del repo

Configuración operativa para usar Oh My OpenAgent **exclusivamente** con OpenCode Go ($10/mes), siguiendo filosofía de tiered routing.

**Caso de uso oficialmente documentado por OMO:** `bunx oh-my-opencode install --opencode-go=yes`
Nosotros lo hacemos manualmente para máximo control.

## Decisiones clave tomadas

1. **Go-Only:** Todos los modelos forzados a `opencode-go/*`. Sin fallbacks a Zen/Anthropic/OpenAI.
2. **JSON como fuente de verdad:** Los `.md` explican filosofía, no listan modelos específicos.
3. **big-pickle excluido:** Si todos los modelos Go fallan, error limpio (no degradación silenciosa).
4. **Zen on-demand:** Solo manual bajo demanda para arquitectura crítica o incidentes.
5. **Repo-first:** `~/git/opencode-omo-sota/opencode-go/oh-my-openagent.json` lidera. La activa sigue.
6. **Versionado SemVer:** Los cambios de config JSON van con git tags (`v1.0.0`, `v1.1.0`). Rollback: `git checkout <tag> -- json && ./setup.sh`.

## Comandos útiles

```bash
# Navegar al repo
repos

# Ver modelos disponibles
opencode models opencode-go

# Validar JSON
python3 -m json.tool opencode-go/oh-my-openagent.json > /dev/null

# Ver salud de OMO
/root/.cache/opencode/packages/oh-my-openagent@latest/node_modules/.bin/oh-my-openagent doctor

# Actualizar cache de modelos
/root/.cache/opencode/packages/oh-my-openagent@latest/node_modules/.bin/oh-my-openagent refresh-model-capabilities

# Copiar config activa al repo (si se editó manualmente)
cp ~/.config/opencode/oh-my-openagent.json ~/git/opencode-omo-sota/opencode-go/
```

## Qué hacer al iniciar sesión

1. Verificar que el repo está en `~/git/opencode-omo-sota`
2. Si hay cambios pendientes en la config activa, sincronizar con el repo
3. Revisar si OpenCode/OMO han actualizado algo relevante
4. Trabajar sobre el repo, commitear y hacer push

## Notas de mantenimiento

- **Auditoría de modelos:** Usar `opencode-go/docs/audit-checklist.md` cada 30 días o cuando haya novedades en Go/AA. Contrasta benchmarks de Artificial Analysis con pricing real de OpenCode Go.
- Si cambias un modelo en el JSON, actualizar CHANGELOG.md y changelog-config.md.
- Los `.md` no deben listar modelos específicos (mantener JSON como fuente de verdad).
- `setup.sh` sirve tanto para instalar como para auditar la configuración.

## Links

- Repo: https://github.com/hrodres/opencode-omo-sota
- OMO Docs: https://ohmyopenagent.com/docs
- OpenCode Go: https://opencode.ai/go/
