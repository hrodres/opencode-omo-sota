# OpenCode + OMO

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub last commit](https://img.shields.io/github/last-commit/hrodres/opencode-omo-sota)](https://github.com/hrodres/opencode-omo-sota/commits/main)

> **Routing SOTA para OpenCode + OMO**
>
> Fuente de verdad operativa para configuraciones de [Oh My OpenAgent](https://github.com/code-yeongyu/oh-my-openagent) con planes de modelo específicos.

## ¿Qué es esto?

Este repositorio contiene configuraciones funcionales y documentadas para usar [OpenCode](https://opencode.ai/) + Oh My OpenAgent (OMO) con diferentes planes de suscripción, aplicando la filosofía de **tiered model routing** descrita en el artículo de [Jatin K Malik](https://medium.com/@jatinkrmalik/opencode-go-oh-my-openagent-the-complete-guide-to-sota-model-routing-without-hitting-limits-49fdc8cb3417).

Cada carpeta representa un **plan de suscripción** (`opencode-go/`, `zen/`, etc.) y es **self-contained**: contiene la configuración JSON operativa, el prompt para recrearla/actualizarla, y su propia documentación.

> ### ✅ Caso de uso oficialmente documentado
>
> Esta configuración **no es un hack**. Los autores de Oh My OpenAgent documentan explícitamente el escenario *"User has OpenCode Go only"* en su [guía de instalación](https://ohmyopenagent.com/docs):
>
> ```bash
> bunx oh-my-opencode install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes
> ```
>
> Nosotros implementamos este mismo caso de uso manualmente (editando el JSON directamente) para máximo control y transparencia.

## Estructura

```
opencode-omo-sota/
├── README.md              # Este archivo
├── setup.sh               # Script de instalación automatizada
├── opencode-go/           # Plan OpenCode Go ($10/mes)
│   ├── oh-my-openagent.json  # Configuración operativa
│   ├── PROMPT.md             # Prompt para recrear/actualizar
│   └── README.md             # Guía específica del plan
├── docs/
│   ├── verification.md     # Checklist post-configuración
│   ├── session-example.md  # Caso de uso real
│   ├── architecture.md     # Stack completo
│   └── reference/          # Materiales de referencia
└── CHANGELOG.md
```

## Instalación rápida

```bash
# Clonar repo
git clone https://github.com/hrodres/opencode-omo-sota.git
cd opencode-omo-sota

# Instalar o auditar configuración (backup, validación JSON, verificación de auth y modelos)
./setup.sh opencode-go

# O instalar manualmente siguiendo la guía de opencode-go/README.md
```

### Go-Only vs. Setup estándar de OMO

OMO por defecto asume que tienes **múltiples suscripciones** (Anthropic, OpenAI, GitHub Copilot, OpenCode/Zen) y orquesta entre ellas para usar el mejor modelo para cada tarea.

Esta configuración toma el enfoque **opuesto y conservador**:

| | Setup estándar OMO | Configuración Go-Only (esta repo) |
|---|---|---|
| **Filosofía** | Usa todos los providers disponibles | Usa **exclusivamente** OpenCode Go |
| **Modelos** | Mixtos según agente y disponibilidad | Todos forzados a `opencode-go/*` |
| **Fallbacks** | Chains multi-provider con auto-fallback | Solo `opencode-go/...` → error limpio |
| **Coste** | Variable, depende de qué modelo caiga | Predecible, dentro de límites de Go |
| **Zen** | Disponible como provider más | Desconectado explícitamente |

**¿Cuándo usar esta configuración?**
- Quieres **costes predecibles** sin sorpresas de API
- No tienes (o no quieres usar) suscripciones de Anthropic, OpenAI, etc.
- Prefieres **transparencia total** sobre qué modelo se ejecuta en cada tarea

### ⚠️ OpenCode + OMO no es un chatbot general

OpenCode es una herramienta de **software development**. OMO es un **equipo de ingenieros especializados**.

- **Para coding:** Excelente
- **Para charla/consultas generales:** Considera ChatGPT/Claude (gratis)

Una sesión larga de consultas en OpenCode puede costar $1-2 USD. La misma conversación fuera de OpenCode es gratuita.

## ⚠️ Importante: `setup.sh` no instala software

**`setup.sh` solo copia y valida la configuración JSON.** No instala OpenCode, Oh My OpenAgent ni ninguna dependencia. Asume que ya tienes:

- [OpenCode](https://opencode.ai/) instalado (`opencode --version`)
- [Oh My OpenAgent](https://github.com/code-yeongyu/oh-my-openagent) instalado (`bunx oh-my-openagent install`)
- Suscripción activa (`opencode auth login`)

Si necesitas instalar el software desde cero, sigue la guía completa en [`opencode-go/README.md`](opencode-go/README.md).

Para más detalles, ver [`opencode-go/README.md`](opencode-go/README.md).

## Filosofía: Tiered Model Routing

No uses un solo modelo para todo. Cada agente tiene un trabajo diferente y debe usar el modelo adecuado según complejidad y coste:

| Tier | Modelos | Uso | Requests/5h |
|---|---|---|---|
| **Tier 1** | DeepSeek V4 Flash, Qwen3.5 Plus | Volumen, búsquedas, tareas rápidas | ~31,000 |
| **Tier 2** | DeepSeek V4 Pro, Qwen3.6 Plus | Ingeniería estándar, implementación | ~3,300 |
| **Tier 3** | Kimi K2.6, GLM-5.1, MiMo V2.5 | Agentic complejo, arquitectura, reasoning | ~1,000-1,500 |

**Regla de oro:** Si una tarea requiere más de 100 requests, empieza por Tier 1 y escala solo si se atasca.

## Capacidades de los modelos

Consulta [`docs/capabilities.md`](docs/capabilities.md) para benchmarks y evaluación de los modelos configurados.

**Resumen:**
- **V4 Pro:** Excelente para backend y APIs (LiveCodeBench 93.5%)
- **K2.6:** Óptimo para orquestación y agentic
- **GLM-5.1:** Mejor reasoning para planning y arquitectura
- **MiMo V2.5:** Multimodal (lectura de imágenes, no generación)

## Planes disponibles

### [opencode-go/](opencode-go/)

Plan de suscripción de $10/mes con acceso a modelos open-source de última generación (Kimi K2.6, DeepSeek V4 Pro, GLM-5.1, etc.).

- **Ventaja:** Coste fijo, límites generosos, 80-90% de calidad frontier
- **Compromiso:** Necesita 1-2 iteraciones extra en arquitectura compleja
- **Ideal para:** Desarrollo diario, agentic workflows, CI/CD

## Cómo usar este repo

### Para configurar por primera vez

1. Clona este repo o copia la carpeta del plan que necesites
2. Sigue la guía específica en `opencode-go/README.md`
3. Copia el `oh-my-openagent.json` a `~/.config/opencode/`
4. Reinicia el servidor OpenCode

### Para actualizar modelos

Cuando OpenCode añada nuevos modelos o retire otros:

1. Abre `PROMPT.md` de la carpeta correspondiente
2. Sigue las instrucciones de "Actualización"
3. Valida que el JSON sigue siendo válido

## Seguridad y buenas prácticas

- **Nunca subas `auth.json`** a este repo (está en `.gitignore`)
- **Haz backups locales** antes de cambios (`cp oh-my-openagent.json oh-my-openagent.json.backup-$(date)`)
- **Mantén Zen desconectado por defecto** si no lo usas activamente

## Recursos

- [Oh My OpenAgent - GitHub](https://github.com/code-yeongyu/oh-my-openagent)
- [OpenCode Go Docs](https://opencode.ai/docs/go/)
- [Artículo base - Jatin K Malik](https://medium.com/@jatinkrmalik/opencode-go-oh-my-openagent-the-complete-guide-to-sota-model-routing-without-hitting-limits-49fdc8cb3417)

## Licencia

MIT - Usa, modifica y comparte libremente.
