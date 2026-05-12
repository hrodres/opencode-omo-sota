# Changelog - Configuración de Modelos

> Cambios exclusivos de `oh-my-openagent.json`.
> Para cambios del proyecto (docs, setup, infra), ver `../../CHANGELOG.md`.

---

## [1.2.1] - 2026-05-12

### Fixed

- **modelConcurrency**: eliminada entrada obsoleta `glm-5.1: 1`, añadida `mimo-v2.5-pro: 2`
  - Inconsistencia introducida en v1.2.0: se reemplazó glm-5.1 en agentes y categorías pero no se actualizó el mapeo de concurrencia.
  - `mimo-v2.5-pro` se usa en 2 sitios (artistry primario, ultrabrain fallback), por lo que `: 2` es el valor correcto.

### Rollback

```bash
git checkout v1.2.0 -- opencode-go/oh-my-openagent.json
./setup.sh opencode-go
```

---

## [1.2.0] - 2026-05-12

### Changed

- **Artistry**: `glm-5.1` → `mimo-v2.5-pro`
  - Inteligencia (AA Index): 44/51 → 54 (+6-22%)
  - Costo Go blended: $2.15 → $1.00 (-53% input)
  - Eficiencia: 40-60% menos tokens en tareas agenticas (ClawEval)
  - Contexto: 203K → 1M tokens
  - Fallback: `qwen3.6-plus` (sin cambios)

- **Ultrabrain fallback[0]**: `glm-5.1` → `mimo-v2.5-pro`
  - Misma mejora que Artistry. Fallback de hard logic necesita el máximo IQ disponible.
  - Fallbacks: `mimo-v2.5-pro`, `qwen3.6-plus`

### Rationale

Fuente: [Artificial Analysis](https://artificialanalysis.ai/models/mimo-v2-5-pro) (abril 2026) + [OpenCode Go](https://opencode.ai/docs/go) (mayo 2026).

MiMo-V2.5-Pro (Xiaomi) alcanza 54 en AA Intelligence Index, empatado con Kimi K2.6 como #1 open-weights. Supera a GLM-5.1 en ambas variantes (non-reasoning 44, reasoning 51). En benchmarks agenticos reales (SWE-Bench Pro 57.2%, ClawEval 64% Pass³), compite con GPT-5.4 y supera a Claude Opus 4.6. Disponible en OpenCode Go como `opencode-go/mimo-v2.5-pro` con 1,290 req/$12.

### Rollback

```bash
git checkout v1.1.2 -- opencode-go/oh-my-openagent.json
./setup.sh opencode-go
```

---

## [1.1.2] - 2026-05-11

### Fixed

- **git_master**: añadidos `commit_footer` y `git_env_prefix` requeridos por el schema

---

## [1.1.1] - 2026-05-11

### Fixed

- **code-reviewer**: eliminado del JSON. OMO no reconoce este agente.
  - `ALLOWED_AGENTS` de `call_omo_agent` solo acepta: explore, librarian, oracle, hephaestus, metis, momus, multimodal-looker
  - La configuración era ignorada silenciosamente por el runtime

---

## [1.1.0] - 2026-05-11

### Changed

- **Oracle**: `glm-5.1` → `kimi-k2.6`
  - Inteligencia: 51 → 54 (+6%)
  - Costo Go blended: $2.15 → $0.58 (-73%)
  - Fallbacks: `deepseek-v4-pro`, `qwen3.6-plus`

- **Prometheus**: `glm-5.1` → `kimi-k2.6`
  - Misma mejora que Oracle. Consistencia con agentes de planificación.
  - Fallbacks: `qwen3.6-plus`, `deepseek-v4-pro`

- **Ultrabrain**: `glm-5.1` → `kimi-k2.6`
  - Hard logic y arquitectura compleja necesitan el cerebro más grande disponible.
  - Fallbacks: `glm-5.1`, `qwen3.6-plus`

- **Hephaestus**: `deepseek-v4-pro` → `deepseek-v4-flash`
  - Velocidad: 31 → 67 t/s (+116%)
  - Costo: $2.17 → $0.18 (-92%)
  - Fallbacks: `deepseek-v4-pro` (complejidad), `kimi-k2.6`

- **Atlas**: `deepseek-v4-pro` → `deepseek-v4-flash`
  - Misma mejora que Hephaestus. Implementación necesita iteración rápida.
  - Fallbacks: `deepseek-v4-pro`, `kimi-k2.6`

- **Multimodal-looker**: `mimo-v2.5` → `qwen3.6-plus`
  - Motivo: precio opaco de MiMo-V2.5 en Go (no es gratis). Qwen3.6 Plus tiene multimodalidad confirmada.
  - Fallback: `kimi-k2.6`

- **Visual-engineering**: `mimo-v2.5` → `qwen3.6-plus`
  - Misma razón que Multimodal-looker.
  - Fallback: `kimi-k2.6`

### Rationale

Fuente de datos: [Artificial Analysis](https://artificialanalysis.ai) (benchmarks independientes, 2026-05-11) + [OpenCode Go](https://opencode.ai/docs/go) (pricing real de suscripción).

Principio aplicado: **bueno, bonito, barato**. Asignar el modelo más barato que cumpla el umbral de calidad del agente.

### Rollback

```bash
git checkout v1.0.0 -- opencode-go/oh-my-openagent.json
./setup.sh opencode-go
```

---

## [1.0.0] - 2026-05-09

### Added

- Configuración inicial con tiered routing para OpenCode Go.
- Asignación de modelos por agente según complejidad y costo.
- Fallbacks exclusivamente dentro de `opencode-go/*`.

### Baseline

| Agente | Modelo | Inteligencia (AA) | Costo Go blended |
|--------|--------|-------------------|------------------|
| Sisyphus | kimi-k2.6 | 54 | $0.58 |
| Oracle | glm-5.1 | 51 | $2.15 |
| Prometheus | glm-5.1 | 51 | $2.15 |
| Hephaestus | deepseek-v4-pro | 52 | $2.17 |
| Atlas | deepseek-v4-pro | 52 | $2.17 |
| Multimodal-looker | mimo-v2.5 | 49 | desconocido |
| Visual-engineering | mimo-v2.5 | 49 | desconocido |
| Librarian/Explore/Junior | deepseek-v4-flash | 47 | $0.18 |
| Metis/Momus | qwen3.6-plus | 50 | $1.13 |
| Code-reviewer | kimi-k2.6 | 54 | $0.58 |
