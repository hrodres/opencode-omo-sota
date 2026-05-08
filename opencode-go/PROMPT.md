# Prompt para configurar/actualizar Oh My OpenAgent con OpenCode Go
# Uso: Este prompt sirve tanto para configuración inicial como para actualizaciones

## Contexto del sistema

Tengo OpenCode + Oh My OpenAgent en un servidor LXC.
Me conecto desde OpenChamber (web UI).

## Objetivo

Configurar (o actualizar) oh-my-openagent.json para usar EXCLUSIVAMENTE modelos de OpenCode Go ($10/mes), siguiendo la filosofía del artículo de Jatin K Malik sobre tiered routing.

## Estado actual de autenticación

- OpenCode Go: Conectado (suscripción activa)
- OpenCode Zen (API de pago): Desconectado por defecto. Si se necesita, se conecta MANUALMENTE bajo demanda.

## Reglas de oro

1. SOLO usar modelos con prefijo `opencode-go/`
2. NUNCA usar `opencode-zen` ni `opencode/` (modelos de pago) como fallback automático
3. Los modelos de pago solo se usan si el usuario los selecciona EXPLÍCITAMENTE
4. Mantener arquitectura por tiers:
   - Tier 1 (Volumen): deepseek-v4-flash, qwen3.5-plus, minimax-m2.5
   - Tier 2 (Estándar): deepseek-v4-pro, qwen3.6-plus, minimax-m2.7
   - Tier 3 (Élite): kimi-k2.6, glm-5.1, mimo-v2.5

## Pasos a seguir

### Si es PRIMERA VEZ (no existe oh-my-openagent.json o está vacío):

1. Backup del archivo existente (si hay): `cp oh-my-openagent.json oh-my-openagent.json.backup-$(date)`
2. Leer artículo de referencia (filosofía, no copiar modelos literalmente):
   https://medium.com/@jatinkrmalik/opencode-go-oh-my-openagent-the-complete-guide-to-sota-model-routing-without-hitting-limits-49fdc8cb3417
3. Ejecutar: `opencode models opencode-go` (ver modelos reales disponibles HOY)
4. Diseñar configuración completa:
   - Asignar modelo principal y fallbacks para cada agente según tiers
   - Configurar rate limit resilience (cooldowns, retry_on_errors)
   - Configurar concurrencia (providerConcurrency, modelConcurrency)
5. Escribir archivo completo
6. Validar JSON
7. Reiniciar opencode serve si es necesario

### Si es ACTUALIZACIÓN (ya existe configuración funcional):

1. Backup: `cp oh-my-openagent.json oh-my-openagent.json.backup-$(date)`
2. Ejecutar: `opencode models opencode-go` (ver modelos disponibles hoy)
3. Comparar con config actual:
   - Identificar modelos deprecados (ya no disponibles)
   - Identificar nuevos modelos relevantes
   - Verificar que fallbacks sigan siendo opencode-go/*
4. Actualizar SOLO lo necesario:
   - Reemplazar modelos obsoletos por equivalentes del mismo tier
   - Ajustar fallbacks si hay nuevas opciones mejores
   - Mantener estructura y concurrencia salvo que cambien límites
5. Validar JSON
6. Reiniciar opencode serve si es necesario

## Configuración de referencia (verificar contra modelos reales actuales)

### Agents (según artículo - adaptar modelos si cambiaron)
- sisyphus: Tier 3 (kimi-k2.6) → Tier 2 (deepseek-v4-pro) → Tier 2 (qwen3.6-plus)
- hephaestus: Tier 2 (deepseek-v4-pro) → Tier 1 (deepseek-v4-flash) → Tier 3 (kimi-k2.6)
- oracle: Tier 3 (glm-5.1) → Tier 3 (kimi-k2.6) → Tier 2 (deepseek-v4-pro)
- librarian: Tier 1 (deepseek-v4-flash) → Tier 1 (qwen3.5-plus)
- explore: Tier 1 (deepseek-v4-flash)
- multimodal-looker: Tier 3 (mimo-v2.5) → Tier 2 (qwen3.6-plus)
- prometheus: Tier 3 (glm-5.1) → Tier 2 (qwen3.6-plus) → Tier 2 (deepseek-v4-pro)
- metis: Tier 2 (qwen3.6-plus) → Tier 2 (deepseek-v4-pro)
- momus: Tier 2 (qwen3.6-plus) → Tier 3 (kimi-k2.6)
- atlas: Tier 2 (deepseek-v4-pro) → Tier 1 (deepseek-v4-flash)
- code-reviewer: Tier 3 (kimi-k2.6) → Tier 2 (deepseek-v4-pro)
- sisyphus-junior: Tier 1 (deepseek-v4-flash)

### Categories
- visual-engineering: Tier 3 (mimo-v2.5) → Tier 2 (qwen3.6-plus)
- ultrabrain: Tier 3 (glm-5.1) → Tier 3 (kimi-k2.6)
- deep: Tier 3 (kimi-k2.6) → Tier 2 (deepseek-v4-pro)
- artistry: Tier 3 (glm-5.1) → Tier 2 (qwen3.6-plus)
- quick: Tier 1 (deepseek-v4-flash)
- unspecified-low: Tier 1 (deepseek-v4-flash)
- unspecified-high: Tier 2 (deepseek-v4-pro) → Tier 3 (kimi-k2.6)
- writing: Tier 2 (qwen3.6-plus)

### Rate Limit & Concurrency (verificar límites actuales)
```json
{
  "model_fallback": true,
  "runtime_fallback": {
    "enabled": true,
    "retry_on_errors": [400, 429, 503, 529],
    "max_fallback_attempts": 3,
    "cooldown_seconds": 60,
    "timeout_seconds": 30,
    "notify_on_fallback": true
  },
  "background_task": {
    "defaultConcurrency": 5,
    "staleTimeoutMs": 180000,
    "providerConcurrency": {
      "opencode-go": 10
    },
    "modelConcurrency": {
      "opencode-go/kimi-k2.6": 2,
      "opencode-go/deepseek-v4-pro": 3,
      "opencode-go/deepseek-v4-flash": 20,
      "opencode-go/glm-5.1": 1,
      "opencode-go/qwen3.6-plus": 5
    }
  }
}
```

## Validación final

Después de cualquier cambio:
1. `python3 -m json.tool ~/.config/opencode/oh-my-openagent.json > /dev/null`
2. Verificar que TODOS los modelos tengan prefijo `opencode-go/`
3. Verificar que no haya `opencode/` ni `opencode-zen/` en fallbacks automáticos
4. `opencode auth list` → Confirmar que Zen no está conectado (a menos que se haya hecho manualmente)
5. Si se reconectó Zen, asegurar que sea temporal y desconectar al finalizar la tarea

## Nota sobre modelos

Los modelos exactos pueden cambiar. Si un modelo del artículo no está disponible (`opencode models opencode-go` no lo lista):
- Buscar el modelo más cercano del mismo tier
- Priorizar modelos del mismo fabricante (ej: si falta qwen3.6-plus, usar qwen3.5-plus)
- Cuando haya duda, consultar al usuario antes de asignar
