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
| `PROMPT.md` | Prompt para recrear o actualizar esta configuración |
| `docs/changelog-config.md` | Historial de cambios del JSON con justificación técnica |
| `docs/prompt-auditoria.md` | Prompt para auditoría de modelos (copiar y pegar al inicio de sesión) |

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

<img src="../images/mapa-agentes.png" alt="Mapa de Agentes OpenCode" width="100%">

La configuración organiza los modelos en 3 tiers. Los modelos exactos, sus límites de requests y asignación por agente están definidos en [`oh-my-openagent.json`](oh-my-openagent.json).

### Principios de asignación

| Tier | Característica | Uso típico |
|---|---|---|
| **Tier 1 - Volumen** | Ultra-rápidos, nunca rate-limited | Búsquedas, exploración de código, tareas rápidas |
| **Tier 2 - Estándar** | Balance calidad/coste | Implementación, debugging, review |
| **Tier 3 - Élite** | Máxima calidad, límites ajustados | Orchestración, arquitectura, reasoning |

**Regla de oro:** Librarian y Explore usan Tier 1. Hephaestus y Atlas usan Tier 2. Sisyphus, Oracle y Prometheus usan Tier 3. Ver JSON para modelos exactos.

## Calidad de los modelos: análisis honesto

### Fortalezas reales (benchmarks)

Los modelos exactos y sus benchmarks están en [`oh-my-openagent.json`](oh-my-openagent.json). En general, el ecosistema Go muestra:

| Tier | Fortaleza típica | Benchmark aproximado |
|---|---|---|
| **Tier 1** | Velocidad y coste | ~30,000 req/5h. Indistinguible de frontier para tareas simples |
| **Tier 2** | Programación competitiva, agentic | ~60-93% en benchmarks especializados. Competitivo con frontier |
| **Tier 3** | SWE-Pro, reasoning | ~58-65%. A 5-10 puntos de Claude Opus/GPT-5.5 en los benchmarks más exigentes |

### Compromisos reales (dónde pierde el ecosistema Go vs. frontier)

| Escenario | Go vs. Frontier | ¿Se nota? |
|---|---|---|
| **Bugs de producción sutiles** | ~58% vs ~64% SWE-Pro | ⚠️ Frontier necesita 1 iteración menos |
| **Arquitectura desde cero** | Tier 3 vs Claude Opus | ⚠️ En sistemas desconocidos, frontier razona mejor |
| **Code review de seguridad** | Tier 3 vs GPT-5.5 | ⚠️ Frontier detecta vulnerabilidades sutiles |
| **Tecnologías muy nuevas** | Go models vs Claude | ⚠️ Menos contexto que modelos premium |

### Veredicto práctico

> **Para el 80% del trabajo diario (features, debug, review, refactor), los modelos Go son indistinguibles de Claude/GPT.** La diferencia solo se nota en el 20% más difícil.

**Tus datos de uso confirman esto:**
- Tier 1 procesa el 90%+ del volumen sin problemas
- Tier 3 solo se usa para orquestación (decisiones estratégicas)
- Coste real: ~$0.20-0.40/hora de trabajo productivo

### Cuándo considerar frontier (Zen on-demand)

Conectar Zen manualmente solo para:
1. **Incidentes de producción** → Claude Opus razona mejor bajo presión
2. **Arquitectura desde cero** → GPT-5.5/Claude diseñan mejor sistemas nuevos
3. **Code review de seguridad** → Opus detecta vulnerabilidades sutiles
4. **Cuando un modelo Go "se atasca"** → Si después de 3 iteraciones no resuelve, escalas a frontier

### Asignación por agente

La asignación exacta de modelos y fallbacks por agente está en [`oh-my-openagent.json`](oh-my-openagent.json). No se duplica aquí para evitar desincronización.

**Filosofía general:**
- **Sisyphus** (orchestrador): Tier 3. Necesita máxima calidad para decisiones estratégicas
- **Oracle/Prometheus** (planning): Tier 3. Reasoning complejo y spec-writing
- **Hephaestus/Atlas** (ejecución): Tier 2. Balance de calidad y coste
- **Librarian/Explore** (búsqueda): Tier 1. Velocidad y volumen
- **Code-reviewer**: Tier 3. Review crítico requiere máxima calidad
- **Metis/Momus** (análisis): Tier 2. Análisis balanceado

## Cómo se derivó esta configuración

Oh My OpenAgent está diseñado para **multi-proveedor** (Anthropic, OpenAI, Google, OpenCode Go, etc.). Sus cadenas internas (`fallbackChain`) recomiendan modelos de diferentes proveedores según el rol de cada agente.

Esta configuración **traduce** esas recomendaciones al ecosistema **OpenCode Go**:
- Por cada agente, identifica el **tier** que OMO recomienda (basado en complejidad de la tarea)
- Busca en OpenCode Go el modelo del **mismo tier** que mejor encaje con la personalidad del agente
- Asigna **fallbacks** exclusivamente dentro del ecosistema Go

**Clave:** No es una copia literal de las `fallbackChain` del plugin (eso requeriría Anthropic, OpenAI, Google). Es una **traducción deliberada** de la filosofía de OMO al plan Go.

Los modelos exactos resultantes de esta traducción están en [`oh-my-openagent.json`](oh-my-openagent.json).

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

OMO no asigna modelos al azar. Cada agente tiene un modelo que encaja con su **personalidad de trabajo**. La asignación exacta está en [`oh-my-openagent.json`](oh-my-openagent.json).

| Agente | Personalidad | Tier típico | Por qué ese tier encaja |
|---|---|---|---|
| **Sisyphus** | Líder sociable. Coordina, delega, comunica. Nunca se rinde. | Tier 3 | Sigue instrucciones complejas de ~1,100 líneas, mantiene flujo de conversación entre múltiples tool calls |
| **Hephaestus** | Especialista profundo. Trabaja solo, emerge con soluciones. | Tier 2 | Razonamiento profundo, explora autónomamente sin supervisión |
| **Oracle** | Consultor arquitectónico. Lee, analiza, no toca código. | Tier 3 | Excelente reasoning lógico y análisis profundo |
| **Librarian** | Buscador rápido. Encuentra documentación y ejemplos. | Tier 1 | Velocidad ultra-rápida, nunca rate-limited |

> **Cambiar el modelo = cambiar el cerebro.** Las mismas instrucciones se entienden completamente diferente según el modelo asignado.

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

### ¿Con qué frecuencia debo revisar modelos?

**Solo cuando sea necesario.** No hay valor en revisar periódicamente "por si acaso".

Revisa cuando:
- Un modelo deja de funcionar (error en logs)
- OpenCode anuncia nuevos modelos
- Ves rate limits inesperados
- Un agente empieza a usar fallbacks con frecuencia anormal

**No revises cuando:**
- Todo funciona correctamente
- Los logs muestran routing correcto
- No has tocado la configuración en semanas

> La filosofía es: **si funciona, no lo toques.** Los modelos no cambian de la noche a la mañana.

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
- `agent=Sisyphus` → `modelID=<tier-3-model>` (modelo de élite para orquestación)
- `agent=librarian` → `modelID=<tier-1-model>` (modelo de volumen para búsqueda)

(El modelo exacto depende de tu configuración actual en `oh-my-openagent.json`)

Si ambos usan el mismo modelo (ej. Tier 3), revisa que el plugin OMO esté cargado en `opencode.json`.

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
