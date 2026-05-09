# Changelog

> Registro de cambios en la configuración y documentación.

## [2026-05-09] - Validación oficial, workflow modes, telemetría, schema

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
- ✅ `oh-my-openagent doctor` ejecutable en el servidor
- ✅ `refresh-model-capabilities` actualiza 2318 modelos
- ✅ Cache refleja disponibilidad real de `mimo-v2.5`
- ✅ Telemetría desactivada en entorno: `OMO_SEND_ANONYMOUS_TELEMETRY=0`

## [2026-05-08] - Configuración inicial OpenCode Go

### Añadido
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
- ✅ JSON válido y completo
- ✅ Auth: Solo OpenCode Go conectado
- ✅ Modelos configurados existen en `opencode models opencode-go`
- ✅ Tiered routing funciona (Sisyphus usa K2.6, Librarian usa V4 Flash)
- ✅ Logs confirman modelos por agente
- ✅ Fallbacks solo contienen `opencode-go/*`
- ✅ Cero referencias a Zen en configuración

### Basado en
- Artículo: [Jatin K Malik - OpenCode Go + OMO Guide](https://medium.com/@jatinkrmalik/opencode-go-oh-my-openagent-the-complete-guide-to-sota-model-routing-without-hitting-limits-49fdc8cb3417)
- Plugin: [Oh My OpenAgent v4.0.0](https://github.com/code-yeongyu/oh-my-openagent)

### Notas
- Configuración adaptada de modelos multi-proveedor (OMO default) a ecosistema Go exclusivo
- mimo-v2.5 usado en lugar de mimo-v2-omni (modelo no disponible en Go actualmente)
- big-pickle no incluido como fallback (se prefiere error limpio a degradación de calidad)

---

## Plantilla para futuras entradas

### [YYYY-MM-DD] - Actualización de modelos

### Cambiado
- Reemplazado `modelo-viejo` por `modelo-nuevo` (mismo tier)
- Ajustada concurrencia de `modelo` de X a Y (nuevos límites)

### Verificado
- ✅ `opencode models opencode-go` confirma disponibilidad
- ✅ Logs muestran routing correcto

### Notas
- Razón del cambio: deprecación/nuevo modelo mejor

---

### [YYYY-MM-DD] - Cambio de proveedor

### Añadido/Eliminado
- Nuevo plan: `zen/` o `copilot/`
- Eliminado plan: `go/` (si se migra)

### Verificado
- ✅ Auth actualizado
- ✅ Configuración testeada end-to-end
