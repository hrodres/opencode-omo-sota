# OpenCode Go - Oh My OpenAgent

> Configuración operativa para usar Oh My OpenAgent **exclusivamente** con modelos del plan [OpenCode Go](https://opencode.ai/go/) ($10/mes).

## ¿Qué incluye este plan?

- **14 modelos SOTA** open-source: Kimi K2.6, DeepSeek V4 Pro, GLM-5.1, Qwen3.6 Plus, MiMo V2.5...
- **Coste fijo:** $10/mes sin sorpresas de API
- **Límites:** $12/5h, $30/semana, $60/mes

## Archivos en esta carpeta

| Archivo | Propósito |
|---|---|
| `oh-my-openagent.json` | Configuración operativa lista para copiar a `~/.config/opencode/` |
| `PROMPT.md` | Instrucciones para recrear o actualizar esta configuración |

## Instalación rápida

### 1. Prerrequisitos

- [OpenCode](https://opencode.ai/) instalado (v1.0.133+)
- [Oh My OpenAgent](https://github.com/code-yeongyu/oh-my-openagent) instalado
- Suscripción OpenCode Go activa (`opencode auth login`)

### 2. Aplicar configuración

```bash
# Backup de tu config actual (si existe)
cp ~/.config/opencode/oh-my-openagent.json ~/.config/opencode/oh-my-openagent.json.backup-$(date +%Y%m%d)

# Copiar configuración
mkdir -p ~/.config/opencode
cp oh-my-openagent.json ~/.config/opencode/

# Validar JSON
python3 -m json.tool ~/.config/opencode/oh-my-openagent.json > /dev/null && echo "✅ Válido"
```

### 3. Verificar autenticación

```bash
opencode auth list
```

Debe mostrar solo:
```
●  OpenCode Go  [api]
```

**Si ves OpenCode Zen conectado** y no lo quieres usar automáticamente:
```bash
# Desconectar Zen temporalmente
# (Zen debe conectarse MANUALMENTE bajo demanda)
```

### 4. Reiniciar servidor

```bash
pkill -f "opencode serve"
opencode serve --hostname 127.0.0.1 --port 37915 &
```

## Arquitectura de esta configuración

### Tier 1 - Volumen (nunca rate-limited)

| Modelo | Requests/5h | Uso |
|---|---|---|
| `deepseek-v4-flash` | 31,650 | Búsquedas, tareas rápidas, review |
| `qwen3.5-plus` | ~5,000 | Librarian, exploración código |

### Tier 2 - Estándar (balance calidad/coste)

| Modelo | Requests/5h | Uso |
|---|---|---|
| `deepseek-v4-pro` | 3,300 | Implementación features, debugging |
| `qwen3.6-plus` | 3,300 | Review, análisis, writing |

### Tier 3 - Élite (máxima calidad, límites ajustados)

| Modelo | Requests/5h | Uso |
|---|---|---|
| `kimi-k2.6` | 1,150 | Orchestración, Sisyphus, code-review |
| `glm-5.1` | 880 | Arquitectura, planning, Oracle/Prometheus |
| `mimo-v2.5` | 1,290 | Tareas multimodales, visual-engineering |

### Asignación por agente

| Agente | Modelo | Fallbacks |
|---|---|---|
| **Sisyphus** (orchestrador) | `kimi-k2.6` | `deepseek-v4-pro` → `qwen3.6-plus` |
| **Hephaestus** (deep worker) | `deepseek-v4-pro` | `deepseek-v4-flash` → `kimi-k2.6` |
| **Oracle** (arquitectura) | `glm-5.1` | `kimi-k2.6` → `deepseek-v4-pro` |
| **Prometheus** (planner) | `glm-5.1` | `qwen3.6-plus` → `deepseek-v4-pro` |
| **Librarian** (búsqueda) | `deepseek-v4-flash` | `qwen3.5-plus` |
| **Explore** (grep) | `deepseek-v4-flash` | - |
| **Code-reviewer** | `kimi-k2.6` | `deepseek-v4-pro` |
| **Metis/Momus** (review) | `qwen3.6-plus` | `deepseek-v4-pro` / `kimi-k2.6` |
| **Atlas** (ejecutor) | `deepseek-v4-pro` | `deepseek-v4-flash` |

## Cómo se derivó esta configuración

Oh My OpenAgent está diseñado para **multi-proveedor** (Anthropic, OpenAI, Google, OpenCode Go, etc.). Sus cadenas internas (`fallbackChain`) recomiendan modelos de diferentes proveedores según el rol de cada agente.

Esta configuración **traduce** esas recomendaciones al ecosistema **OpenCode Go**, asignando el modelo equivalente del mismo tier:

| Agente | Recomendación OMO | Modelo Go asignado | Tier | Razón |
|---|---|---|---|---|
| **Sisyphus** | Claude Opus 4.7 (Anthropic) | `kimi-k2.6` | 3 Élite | Mejor agentic/orchestration en Go |
| **Oracle** | GPT-5.5 / Gemini-3.1-Pro | `glm-5.1` | 3 Élite | Mejor reasoning y planning en Go |
| **Prometheus** | Claude Opus 4.7 / GPT-5.5 | `glm-5.1` | 3 Élite | Mejor spec-writing en Go |
| **Hephaestus** | GPT-5.5 (OpenAI) | `deepseek-v4-pro` | 2 Estándar | Generalista principle-driven equivalente |
| **Atlas** | Claude Sonnet 4.6 / Kimi K2.5 | `deepseek-v4-pro` | 2 Estándar | Ejecución balanceada |
| **Librarian** | GPT-5.4-mini-fast | `deepseek-v4-flash` | 1 Volumen | Equivalente en velocidad/coste |
| **Explore** | GPT-5.4-mini-fast | `deepseek-v4-flash` | 1 Volumen | Búsquedas masivas, nunca rate-limited |
| **Code-reviewer** | (Sin chain propia) | `kimi-k2.6` | 3 Élite | Máxima calidad para review crítico |
| **Metis/Momus** | Claude Opus / GPT-5.5 | `qwen3.6-plus` | 2 Estándar | Análisis y review balanceado |

**Clave:** No es una copia literal de las `fallbackChain` del plugin (eso requeriría Anthropic, OpenAI, Google). Es una **traducción deliberada** de la filosofía de OMO al plan Go.

## Actualizar modelos

Cuando OpenCode añada nuevos modelos o retire otros:

1. Abre `PROMPT.md` en esta carpeta
2. Sigue la sección "ACTUALIZACIÓN"
3. Ejecuta `opencode models opencode-go` para ver disponibilidad actual
4. Adapta `oh-my-openagent.json` manteniendo la arquitectura por tiers

## Troubleshooting

### "Todos los agentes usan el mismo modelo"

Verifica que el plugin OMO está cargado:
```bash
cat ~/.config/opencode/opencode.json
```
Debe contener:
```json
{ "plugin": ["oh-my-openagent@latest"] }
```

### "Rate limit errors"

Es normal si usas Tier 3 intensivamente. Los fallbacks automáticos gestionan el cambio de modelo. Para evitarlo:
- Reduce `background_task.modelConcurrency` para modelos Tier 3
- Usa Tier 1 para tareas de volumen
- Espera el cooldown (60s por defecto)

### "Modelo no encontrado"

Ejecuta `opencode models opencode-go` y verifica que el modelo existe. Si fue retirado, busca el equivalente del mismo tier y actualiza el JSON.

### "Quiero usar Zen manualmente para una tarea"

```bash
# Conectar Zen (temporal)
opencode auth login

# Seleccionar modelo Zen manualmente
# (el modelo debe tener prefijo opencode-zen/ o ser seleccionado explícitamente)

# Desconectar Zen al terminar
# Editar ~/.local/share/opencode/auth.json y quitar entrada "opencode"
```

## Notas de implementación

- **No se incluye `big-pickle` en fallbacks:** Esta configuración asume que si todos los modelos Go fallan, prefieres un error limpio antes que degradar a calidad gratuita. Si quieres añadirlo como último recurso, añade `"opencode/big-pickle"` al final de cada `fallback_models`.
- **Zen está desconectado por defecto:** Para evitar consumo accidental de créditos de API de pago.
- **Configuración basada en:** Artículo de Jatin K Malik + adaptación a modelos reales disponibles en OpenCode Go.

## Mantenimiento

- Revisar modelos disponibles cada mes (`opencode models opencode-go`)
- Ajustar concurrencia si cambian los límites del plan
- Backup antes de cualquier cambio mayor
