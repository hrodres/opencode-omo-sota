# OpenCode OMO SOTA

> **Fuente de verdad operativa** para configuraciones de [Oh My OpenAgent](https://github.com/code-yeongyu/oh-my-openagent) con planes de modelo específicos.

## ¿Qué es esto?

Este repositorio contiene configuraciones funcionales y documentadas para usar [OpenCode](https://opencode.ai/) + Oh My OpenAgent (OMO) con diferentes planes de suscripción, aplicando la filosofía de **tiered model routing** descrita en el artículo de [Jatin K Malik](https://medium.com/@jatinkrmalik/opencode-go-oh-my-openagent-the-complete-guide-to-sota-model-routing-without-hitting-limits-49fdc8cb3417).

Cada carpeta representa un **plan de suscripción** (`opencode-go/`, `zen/`, etc.) y es **self-contained**: contiene la configuración JSON operativa, el prompt para recrearla/actualizarla, y su propia documentación.

## Estructura

```
opencode-omo-sota/
├── README.md              # Este archivo
├── opencode-go/           # Plan OpenCode Go ($10/mes)
│   ├── oh-my-openagent.json  # Configuración operativa
│   ├── PROMPT.md             # Prompt para recrear/actualizar
│   └── README.md             # Guía específica del plan
└── .gitignore
```

## Filosofía: Tiered Model Routing

No uses un solo modelo para todo. Cada agente tiene un trabajo diferente y debe usar el modelo adecuado según complejidad y coste:

| Tier | Modelos | Uso | Requests/5h |
|---|---|---|---|
| **Tier 1** | DeepSeek V4 Flash, Qwen3.5 Plus | Volumen, búsquedas, tareas rápidas | ~31,000 |
| **Tier 2** | DeepSeek V4 Pro, Qwen3.6 Plus | Ingeniería estándar, implementación | ~3,300 |
| **Tier 3** | Kimi K2.6, GLM-5.1, MiMo V2.5 | Agentic complejo, arquitectura, reasoning | ~1,000-1,500 |

**Regla de oro:** Si una tarea requiere más de 100 requests, empieza por Tier 1 y escala solo si se atasca.

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
