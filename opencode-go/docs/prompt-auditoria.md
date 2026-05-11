# Prompt de Auditoría de Modelos para Sisyphus

> Copiar y pegar al inicio de una sesión para que el agente revise la configuración JSON contra benchmarks actualizados.

---

## INSTRUCCIONES PARA EL AGENTE

Ejecuta una auditoría completa de `opencode-go/oh-my-openagent.json` siguiendo exactamente este proceso:

### 1. LECTURA LOCAL

Lee el archivo de configuración activa:
- `~/git/opencode-omo-sota/opencode-go/oh-my-openagent.json`
- `~/git/opencode-omo-sota/opencode-go/docs/changelog-config.md` (para contexto de cambios previos)

Extrae todos los modelos únicos usados en el JSON (agents + categories).

### 2. BENCHMARKS EXTERNOS

Para **cada modelo encontrado**, consulta **en paralelo**:

**A) Artificial Analysis** (https://artificialanalysis.ai/models/<slug>)
- Busca: Intelligence Index, velocidad (tokens/s), precio API directa, verbosidad
- Slugs típicos: `kimi-k2-6`, `deepseek-v4-pro`, `deepseek-v4-flash`, `glm-5-1`, `qwen3-6-plus`, `mimo-v2-5`, etc.

**B) OpenCode Go** (https://opencode.ai/docs/go)
- Verifica si el modelo sigue disponible en Go
- Extrae estimaciones de requests/$12 (tabla de límites de uso)
- Comprueba si hay modelos nuevos en Go no presentes en el JSON

**C) Modelos nuevos en Go**
- Ejecuta `opencode models opencode-go` si está disponible
- O busca en la doc: ¿hay modelos nuevos desde la última versión del JSON?

### 3. ANÁLISIS COMPARATIVO

Genera una tabla con cada modelo del JSON:

| Modelo | Agente Principal | IQ (AA) | Velocidad (t/s) | Costo Go blended | Req/$12 | Estado |
|--------|-----------------|---------|-----------------|------------------|---------|--------|
| ... | ... | ... | ... | ... | ... | ✅ Óptimo / ⚠️ Revisar / ❌ Retirado |

**Reglas de decisión:**
- **Cambiar** si hay alternativa con: +5% IQ, o -20% costo, o +30% velocidad
- **Alertar** si el modelo está retirado de Go
- **Ignorar** diferencias <5% (ruido)

### 4. PROPUESTA DE CAMBIOS

Si detectas mejoras, presenta:

**Informe ejecutivo (3-6 bullets):**
- Qué modelos cambiar y por qué
- Impacto estimado en costo y rendimiento
- Riesgos (si los hay)

**Tabla de cambios propuestos:**

| Agente/Categoría | Actual | Propuesto | IQ Δ | Costo Δ | Velocidad Δ | ¿Aplicar? |
|------------------|--------|-----------|------|---------|-------------|-----------|
| ... | ... | ... | +X | -Y% | +Z% | [ ] Sí [ ] No |

### 5. NO HACER NADA SIN PERMISO

**IMPORTANTE:** No edites el JSON, no hagas commits, no crees tags. Solo presenta el informe y espera que el usuario diga "adelante" o haga preguntas.

### 6. FORMATO DE RESPUESTA

Estructura tu respuesta así:

```
## Resumen Ejecutivo
[2-3 frases con la conclusión principal]

## Estado de los Modelos Actuales
[Tabla comparativa]

## Hallazgos Clave
- [Bullet 1]
- [Bullet 2]

## Propuestas de Optimización (si aplica)
[Tabla de cambios]

## Recomendación Final
[Aplicar / Mantener / Investigar más]
```

---

## CONTEXTO ADICIONAL (opcional, pegar si aplica)

- **Versión actual del JSON:** [pegar `git describe --tags`]
- **Problemas observados:** [ej: "Oracle parece lento", "Hephaestus consume mucho"]
- **Prioridad del usuario:** [ej: "Minimizar costo" / "Maximizar velocidad" / "Equilibrado"]

---

## EJEMPLO DE USO

```
[Sesión nueva]
Usuario: [pega este prompt completo]

Agente: Lee JSON → Consulta webs → Presenta informe → Espera aprobación

Usuario: "Adelante con los cambios" (o "No, solo quiero saber" o "Cambia solo X")

Agente: Aplica solo lo aprobado → Commit → Tag → Deploy
```

---

*Basado en la auditoría realizada el 2026-05-11 que optimizó v1.0.0 → v1.1.0.*
