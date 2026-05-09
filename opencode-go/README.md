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

**Opción A: Script automatizado (desde la raíz del repo)**

```bash
cd ..
./setup.sh opencode-go
```

Esto hace backup automático, valida JSON, detecta Zen conectado, y verifica modelos.

**Opción B: Manual**

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

## Calidad de los modelos: análisis honesto

### Fortalezas reales (benchmarks)

| Modelo | Fortaleza | Benchmark | Contexto |
|---|---|---|---|
| `deepseek-v4-pro` | Programación competitiva | **LiveCodeBench 93.5%** | Supera a Claude Opus en código competitivo |
| `qwen3.6-plus` | Trabajo terminal/agentic | **Terminal-Bench 61.6%** | Supera a Claude 4.5 (59.3%) |
| `kimi-k2.6` | SWE-Pro (bugs reales) | **58.6%** | A 6 puntos de Claude Opus 4.7 (64.3%) |
| `glm-5.1` | Reasoning y spec-writing | **58.4% SWE-Pro** | Mejor planning del ecosistema Go |
| `deepseek-v4-flash` | Velocidad y coste | **31,650 req/5h** | Indistinguible de frontier para tareas simples |

### Compromisos reales (dónde pierden vs. frontier)

| Escenario | Go vs. Frontier | ¿Se nota? |
|---|---|---|
| **Bugs de producción sutiles** | 58% vs 64% SWE-Pro | ⚠️ Opus necesita 1 iteración menos |
| **Arquitectura desde cero** | GLM-5.1 vs Claude Opus | ⚠️ En sistemas desconocidos, Opus razona mejor |
| **Code review de seguridad** | K2.6 vs GPT-5.5 | ⚠️ Frontier detecta vulnerabilidades sutiles |
| **Tecnologías muy nuevas** | Go models vs Claude | ⚠️ Menos contexto que modelos premium |

### Veredicto práctico

> **Para el 80% del trabajo diario (features, debug, review, refactor), los modelos Go son indistinguibles de Claude/GPT.** La diferencia solo se nota en el 20% más difícil.

**Tus datos de uso confirman esto:**
- V4 Flash procesa el 90%+ del volumen sin problemas
- K2.6 solo se usa para orquestación (decisiones estratégicas)
- Coste real: ~$0.20-0.40/hora de trabajo productivo

### Cuándo considerar frontier (Zen on-demand)

Conectar Zen manualmente solo para:
1. **Incidentes de producción** → Claude Opus razona mejor bajo presión
2. **Arquitectura desde cero** → GPT-5.5/Claude diseñan mejor sistemas nuevos
3. **Code review de seguridad** → Opus detecta vulnerabilidades sutiles
4. **Cuando un modelo Go "se atasca"** → Si después de 3 iteraciones no resuelve, escalas a frontier

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

### Verificar salud con `doctor`

Si tienes el CLI de OMO instalado:

```bash
/root/.cache/opencode/packages/oh-my-openagent@latest/node_modules/.bin/oh-my-openagent doctor
```

Si muestra warnings sobre modelos desconocidos:
```bash
/root/.cache/opencode/packages/oh-my-openagent@latest/node_modules/.bin/oh-my-openagent refresh-model-capabilities
```

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

## Cómo trabajar con OMO

### Los 3 modos de trabajo

La documentación oficial de OMO define tres niveles de interacción según la complejidad de la tarea:

| Complejidad | Qué hacer | Cuándo usar |
|---|---|---|
| **Simple** | Escribe el prompt directamente | Tareas rápidas, fixes de un archivo, cambios triviales |
| **Compleja + Perezosa** | Escribe `ultrawork` o `ulw` | Tareas complejas donde explicar todo el contexto es tedioso. El agente lo descubre solo. |
| **Compleja + Precisa** | `@plan` → `/start-work` | Trabajo multi-paso que requiere orquestación real. Prometheus planea, Atlas ejecuta con verificación. |

**Ejemplos concretos:**
- *Fix:* "Arregla el typo en `utils.py` línea 23" → **Modo Simple**
- *Feature:* "Implementa autenticación JWT en la API" → **Modo `ultrawork`**
- *Refactor:* "Migra todo el proyecto de REST a GraphQL con tests y documentación" → **`@plan` → `/start-work`**

### Filosofía del Model Matching

OMO no asigna modelos al azar. Cada agente tiene un modelo que encaja con su **personalidad de trabajo**:

| Agente | Personalidad | Modelo Go asignado | Por qué encaja |
|---|---|---|---|
| **Sisyphus** | Líder sociable. Coordina, delega, comunica. Nunca se rinde. | `kimi-k2.6` | Sigue instrucciones complejas de ~1,100 líneas, mantiene flujo de conversación entre múltiples tool calls |
| **Hephaestus** | Especialista profundo. Trabaja solo, emerge con soluciones. | `deepseek-v4-pro` | Razonamiento profundo, explora autónomamente sin supervisión |
| **Oracle** | Consultor arquitectónico. Lee, analiza, no toca código. | `glm-5.1` | Excelente reasoning lógico y análisis profundo |
| **Librarian** | Buscador rápido. Encuentra documentación y ejemplos. | `deepseek-v4-flash` | Velocidad ultra-rápida, nunca rate-limited |

> **Cambiar el modelo = cambiar el cerebro.** Las mismas instrucciones se entienden completamente diferente en Kimi vs. GLM vs. DeepSeek.

### Telemetría

Oh My OpenAgent envía **telemetría anónima** por defecto para trackear instalaciones activas (DAU/WAU/MAU). Un único evento por día por máquina, usando un identificador hasheado. No se crean perfiles de usuario.

**Para desactivarla:**
```bash
export OMO_SEND_ANONYMOUS_TELEMETRY=0
# o
export OMO_DISABLE_POSTHOG=1
```

Añade la variable a tu `~/.bashrc` o `~/.zshrc` para que persista.

### Team Mode (avanzado)

OMO incluye un modo experimental de **coordinación multi-agente en paralelo** (similar a Agent Teams de Claude Code).

- **Estado:** OFF por defecto
- **Para habilitar:** Añade al JSON:
```json
{
  "team_mode": {
    "enabled": true,
    "max_parallel_members": 4,
    "max_members": 8
  }
}
```
- Reinicia `opencode serve`
- Disponibles 12 herramientas `team_*`

**Usar cuando:**
- Exploración paralela con coordinación acotada
- Refactors largos divididos entre agentes especializados
- Pipelines de investigación + implementación

Más detalles en la [documentación oficial de OMO](https://ohmyopenagent.com/docs).

## FAQ

### ¿Este JSON instala OpenCode y Oh My OpenAgent automáticamente?

**No.** Solo copia la configuración. Debes tener ya instalados:
- OpenCode (`opencode --version`)
- Oh My OpenAgent (`bunx oh-my-openagent install`)
- Auth activo (`opencode auth login`)

El script `setup.sh` automatiza la copia del JSON con validaciones, pero no instala software.

### ¿Puedo añadir modelos de Zen a los fallbacks?

Puedes, pero este repo está diseñado para evitarlo. Si necesitas Zen:
- **Opción A:** Conecta Zen manualmente (`opencode auth login`) solo cuando lo necesites
- **Opción B:** Crea o usa el preset `zen/` si se añade al repo

Zen no aparece en los fallbacks para evitar consumo accidental de créditos de API.

### ¿Por qué no incluyes `big-pickle` como fallback?

Porque si todos los modelos Go fallan, preferimos un **error limpio** antes que degradar silenciosamente a un modelo de calidad mucho inferior. Puedes añadir `"opencode/big-pickle"` al final de `fallback_models` si prefieres que nunca falle.

### ¿Por qué JSON manual en lugar de `bunx oh-my-opencode install --opencode-go=yes`?

El installer oficial de OMO funciona y está documentado. Sin embargo, esta configuración manual ofrece:

| | Installer oficial (`bunx`) | Configuración manual (este repo) |
|---|---|---|
| **Control** | Automático, opina por ti | Total: eliges cada modelo y fallback |
| **Exclusividad Go** | Depende de tus respuestas | Garantizada: solo `opencode-go/*` en el JSON |
| **Versionado** | No está en tu repo | Git history de cambios, rollback fácil |
| **Fallbacks** | Chains predefinidas OMO | Customizados para Go-Only, sin Zen |
| **Transparencia** | Black box | Cada modelo documentado con su porqué |
| **Aprendizaje** | Ninguno | Entiendes qué hace cada agente |

**Usa el installer oficial** si quieres configurar rápido sin pensar.
**Usa este repo** si quieres entender, controlar, y versionar tu configuración.

### ¿OMO + OpenCode sirven para preguntas generales y configuración?

**No es su fortaleza.** OpenCode es una herramienta de **software development**. OMO es un equipo de **ingenieros especializados**. Ninguno está diseñado para charla general.

| Tipo de sesión | ¿OpenCode + OMO? | Alternativa |
|---|---|---|
| **Coding, debug, refactor** | ✅ Excelente | — |
| **Arquitectura de software** | ✅ Muy bueno | — |
| **Charla técnica, consultas, "qué es X"** | ⚠️ Funciona pero es ineficiente | ChatGPT, Claude web, etc. |

**Por qué:** Cada mensaje en OpenCode consume requests de modelo. Una charla de 200 mensajes con K2.6 cuesta ~$1 USD. La misma conversación en ChatGPT es gratis.

**Recomendación:** Reserva OpenCode + OMO para trabajo real de código. Para charla y consultas, usa herramientas diseñadas para conversación.

### ¿Cómo sé si el tiered routing realmente funciona?

Revisa los logs después de una sesión con delegación:
```bash
# Último log
ls -lt ~/.local/share/opencode/log/ | head -1

# Verificar modelos por agente
grep "service=llm" ~/.local/share/opencode/log/TIMESTAMP.log | grep -E "agent=Sisyphus|agent=librarian"
```

**Esperado:**
- `agent=Sisyphus` → `modelID=kimi-k2.6`
- `agent=librarian` → `modelID=deepseek-v4-flash`

Si ambos usan `kimi-k2.6`, revisa que el plugin OMO esté cargado en `opencode.json`.

### ¿Qué hago si un modelo desaparece de `opencode models opencode-go`?

1. Ejecuta `opencode models opencode-go` para ver disponibilidad actual
2. Busca el equivalente del **mismo tier**:
   - Si falta un Tier 3 (élite), busca otro Tier 3
   - Si falta un Tier 1 (volumen), busca otro Tier 1
3. Actualiza `oh-my-openagent.json` con el nuevo modelo
4. Valida JSON: `python3 -m json.tool oh-my-openagent.json`

### ¿Puedo usar esta config en mi laptop en lugar de un LXC?

Sí. El JSON es independiente de la infraestructura. Solo asegúrate de que:
- `opencode serve` esté corriendo donde esté el JSON
- `~/.config/opencode/oh-my-openagent.json` esté accesible

La diferencia es que en un LXC el servidor siempre está encendido y accesible desde OpenChamber.

### ¿Cómo actualizo cuando salen nuevos modelos?

1. Revisa `PROMPT.md` en esta carpeta → sección "ACTUALIZACIÓN"
2. Sigue los pasos: `opencode models opencode-go` → comparar → actualizar → validar
3. O ejecuta `./setup.sh opencode-go` tras editar el JSON

## Mantenimiento

- Revisar modelos disponibles cada mes (`opencode models opencode-go`)
- Ajustar concurrencia si cambian los límites del plan
- Backup antes de cualquier cambio mayor
