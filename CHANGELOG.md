# Changelog

> Registro de cambios en la configuración y documentación.
>
> Las entradas de configuración JSON usan formato [SemVer](https://semver.org/lang/es/). Para detalles técnicos de cada cambio de modelo, ver `opencode-go/docs/changelog-config.md`.

---

## [1.3.0] - 2026-05-12

### Configuración de modelos (JSON)

- **Hephaestus**: `deepseek-v4-flash` → `deepseek-v4-pro` (fallback: `kimi-k2.6`)
- **Artistry**: `mimo-v2.5-pro` → `qwen3.6-plus` (fallback: `kimi-k2.6`) — cambio crítico para visión multimodal
- **Librarian fallback**: `qwen3.5-plus` → `[qwen3.6-plus, minimax-m2.7]`
- **Resiliencia**: fallbacks añadidos a `explore`, `sisyphus-junior`, `quick`, `unspecified-low`, `writing`
- **modelConcurrency**: `deepseek-v4-pro` 3→6, `qwen3.6-plus` 5→6, `minimax-m2.7` 6 añadido

Ver `opencode-go/docs/changelog-config.md` para análisis técnico completo.

---

## [1.2.2] - 2026-05-12

### Configuración de modelos (JSON)

- **Hephaestus**: añadido `allow_non_gpt_model: true` para señalizar uso intencional de modelo no-GPT

---

## [1.2.1] - 2026-05-12

### Configuración de modelos (JSON)

- **modelConcurrency**: eliminada entrada obsoleta `glm-5.1: 1`, añadida `mimo-v2.5-pro: 2`

---

## [1.2.0] - 2026-05-12

### Configuración de modelos (JSON)

- **Artistry**: `glm-5.1` → `mimo-v2.5-pro` (fallback: `qwen3.6-plus`)
  - AA Intelligence Index: 44/51 → 54. Empatado #1 open-weights con Kimi K2.6.
  - SWE-Bench Pro: 57.2%, supera a Claude Opus 4.6 (53.4%).
  - Eficiencia: 40-60% menos tokens en tareas agenticas vs modelos equivalentes.
- **Ultrabrain fallback[0]**: `glm-5.1` → `mimo-v2.5-pro`

Ver `opencode-go/docs/changelog-config.md` para análisis técnico completo.

---

## [1.1.2] - 2026-05-11

### Configuración de modelos (JSON)

- Añadidos campos faltantes `commit_footer` y `git_env_prefix` en `git_master` (schema validation fix)

---

## [1.1.1] - 2026-05-11

### Configuración de modelos (JSON)

- Eliminado agente `code-reviewer` (OMO no lo reconoce como agente válido; era configuración muerta)

---

## [1.1.0] - 2026-05-11

### Configuración de modelos (JSON)

- **Oracle**: `glm-5.1` → `kimi-k2.6` (fallback: `deepseek-v4-pro`, `qwen3.6-plus`)
- **Prometheus**: `glm-5.1` → `kimi-k2.6` (fallback: `qwen3.6-plus`, `deepseek-v4-pro`)
- **Ultrabrain**: `glm-5.1` → `kimi-k2.6` (fallback: `glm-5.1`, `qwen3.6-plus`)
- **Hephaestus**: `deepseek-v4-pro` → `deepseek-v4-flash` (fallback: `deepseek-v4-pro`, `kimi-k2.6`)
- **Atlas**: `deepseek-v4-pro` → `deepseek-v4-flash` (fallback: `deepseek-v4-pro`, `kimi-k2.6`)
- **Multimodal-looker**: `mimo-v2.5` → `qwen3.6-plus` (fallback: `kimi-k2.6`)
- **Visual-engineering**: `mimo-v2.5` → `qwen3.6-plus` (fallback: `kimi-k2.6`)

### Añadido

- Versionado SemVer con git tags (`v1.0.0`, `v1.1.0`)
- `setup.sh`: muestra versión activa y comando de rollback
- Sección "Versionado y Rollback" en README principal
- `opencode-go/docs/changelog-config.md`: changelog exclusivo del JSON

### Cambiado

- `CHANGELOG.md`: reestructurado para separar cambios de proyecto vs cambios de config

### Justificación

Análisis de benchmarks en [Artificial Analysis](https://artificialanalysis.ai) y pricing de [OpenCode Go](https://opencode.ai/docs/go), 2026-05-11.

**Rollback:**
```bash
git checkout v1.0.0 -- opencode-go/oh-my-openagent.json
./setup.sh opencode-go
```

---

## [1.0.0] - 2026-05-09

### Configuración de modelos (JSON)

- Configuración inicial estable con tiered routing para OpenCode Go.

### Añadido

- Validación de caso de uso oficial: OMO documenta explícitamente "User has OpenCode Go only"
- Sección "Go-Only vs. Setup estándar de OMO" en README principal
- Documentación de los 3 modos de trabajo de OMO (Simple, Ultrawork, Preciso)
- Guía de Model Matching: por qué cada agente tiene su modelo
- Documentación de telemetría (qué recopila OMO, cómo desactivarla)
- Soporte para Team Mode (avanzado, OFF por defecto)
- Schema oficial OMO (`$schema`) en el JSON para validación automática
- `setup.sh`: validación opcional contra schema oficial, prompt para desactivar telemetría
- FAQ: "¿Por qué JSON manual en lugar de bunx installer?"
- `docs/workflow-modes.md`: Guía completa de modos de trabajo
- `docs/telemetry.md`: Transparencia sobre telemetría anónima
- `.gitignore`: Evita subir backups y logs accidentalmente

### Cambiado

- `PROMPT.md`: Corregida inconsistencia con tiers (eliminados minimax no usados)
- `docs/verification.md`: Añadido `oh-my-openagent doctor` como paso de verificación
- `opencode-go/README.md`: Añadido `doctor` en troubleshooting

### Verificado

- `oh-my-openagent doctor` ejecutable en el servidor
- `refresh-model-capabilities` actualiza 2318 modelos
- Cache refleja disponibilidad real de `mimo-v2.5`
- Telemetría desactivada en entorno: `OMO_SEND_ANONYMOUS_TELEMETRY=0`

---

## [0.1.0] - 2026-05-08

### Configuración de modelos (JSON)

- `oh-my-openagent.json` con tiered routing para OpenCode Go
  - Tier 1 (Volumen): deepseek-v4-flash, qwen3.5-plus
  - Tier 2 (Estándar): deepseek-v4-pro, qwen3.6-plus
  - Tier 3 (Élite): kimi-k2.6, glm-5.1, mimo-v2.5
- Rate limit resilience: cooldowns, retry, notify
- Concurrencia optimizada por modelo
- Zen desconectado por defecto (solo manual bajo demanda)
- `PROMPT.md` para recrear/actualizar la configuración
- `README.md` con guía completa del plan Go
- `docs/verification.md`: Checklist post-configuración
- `docs/session-example.md`: Caso de uso real con evidencia de logs
- `docs/architecture.md`: Stack completo incluyendo OpenChamber

### Verificado

- JSON válido y completo
- Auth: Solo OpenCode Go conectado
- Modelos configurados existen en `opencode models opencode-go`
- Tiered routing funciona (Sisyphus usa K2.6, Librarian usa V4 Flash)
- Logs confirman modelos por agente
- Fallbacks solo contienen `opencode-go/*`
- Cero referencias a Zen en configuración

### Basado en

- Artículo: [Jatin K Malik - OpenCode Go + OMO Guide](https://medium.com/@jatinkrmalik/opencode-go-oh-my-openagent-the-complete-guide-to-sota-model-routing-without-hitting-limits-49fdc8cb3417)
