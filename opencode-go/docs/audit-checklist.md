# Checklist de Auditoría de Modelos

> Proceso manual para revisar si `oh-my-openagent.json` sigue siendo óptimo.
> Contrasta modelos disponibles en OpenCode Go con benchmarks de Artificial Analysis.
>
> Tiempo estimado: 30-45 minutos.

---

## ¿Cuándo ejecutar?

- [ ] **Nuevo modelo** anunciado en OpenCode Go (newsletter, Discord, changelog)
- [ ] **Cambio de precios** en Go (revisar https://opencode.ai/docs/go)
- [ ] **Revisión rutinaria** (cada 30 días, marca en calendario)
- [ ] **Problemas detectados**: fallos frecuentes, lentitud inesperada, coste mensual alto

---

## Paso 1: Inventario Actual

Extraer los modelos únicos de tu configuración activa:

```bash
cd ~/git/opencode-omo-sota
grep -oE 'opencode-go/[a-z0-9.-]+' opencode-go/oh-my-openagent.json | sort -u
```

Anotar versión actual:
```bash
git describe --tags --always
# Resultado esperado: vX.Y.Z
```

**Modelos actuales (v_______):**

| Modelo | Agente/Categoría Principal | Rol |
|--------|---------------------------|-----|
| `opencode-go/_________` | _______ | _______ |
| `opencode-go/_________` | _______ | _______ |
| ... | ... | ... |

---

## Paso 2: Catálogo Actual de OpenCode Go

Listar todos los modelos disponibles hoy:

```bash
opencode models opencode-go
```

**Nuevos modelos** (disponibles ahora, no en tu JSON):

| Modelo | ¿Multimodal? | Contexto | ¿Lo evalúo? |
|--------|-------------|----------|-------------|
| `_________` | □ Sí □ No | _______ | □ Sí □ No |

**Modelos retirados** (en tu JSON pero ya no disponibles):

| Modelo | Agente que lo usa | Acción: reemplazar por... |
|--------|------------------|---------------------------|
| `_________` | _______ | `_________` |

---

## Paso 3: Benchmarks en Artificial Analysis

Para **cada modelo en uso**, buscar en https://artificialanalysis.ai/models/<slug>:

**Búsqueda rápida (copiar y pegar en Google):**
```
site:artificialanalysis.ai <model-name> intelligence index speed price
```

**Plantilla de registro:**

| Modelo | Intelligence Index | Velocidad (t/s) | Precio API In/Out | Precio Blended Go | Req/$12 (5h) |
|--------|-------------------|-----------------|-------------------|-------------------|-------------|
| `kimi-k2.6` | 54 | 50.2 | $0.95/$4.00 | **$0.58** | 1,150 |
| `deepseek-v4-pro` | 52 | ~31 | $1.74/$3.48 | **$2.17** | 3,450 |
| `deepseek-v4-flash` | 47 | 67.5 | $0.14/$0.28 | **$0.18** | 31,650 |
| `glm-5.1` | 51 | 56.5 | $1.40/$4.40 | **$2.15** | 880 |
| `qwen3.6-plus` | 50 | 52.4 | $0.50/$3.00 | **$1.13** | 3,300 |
| `_________` | ____ | ____ | ____ | **____** | ____ |

> **Nota**: El "Precio Blended Go" es lo que importa. Puede diferir del precio API directa (OpenCode negocia descuentos). Sacar de https://opencode.ai/docs/go o estimar desde la tabla de requests.

---

## Paso 4: Reglas de Decisión

**Cambiar un modelo SI se cumple AL MENOS UNA:**

- [ ] **+5% IQ** (ej: 51 → 54) con coste similar o menor
- [ ] **-20% costo** (ej: $2.15 → $1.13) con IQ similar o mayor
- [ ] **+30% velocidad** (ej: 31 → 67 t/s) con calidad similar
- [ ] Modelo actual **retirado** o con problemas de disponibilidad

**NO cambiar SI:**

- [ ] Es el modelo de **Sisyphus** (orquestador) sin testear 48h en entorno real
- [ ] La diferencia es **<5%** en todas las variables (ruido, no mejora)
- [ ] La alternativa **pierde capacidad crítica** (ej: deja de ser multimodal si el rol lo necesita)
- [ ] El modelo alternativo tiene **precio opaco** en Go (ej: MiMo-V2.5 históricamente)

---

## Paso 5: Propuesta de Cambios

Completar solo si el Paso 4 arroja candidatos:

| Agente/Categoría | Modelo Actual | Modelo Propuesto | IQ Δ | Costo Δ | Velocidad Δ | ¿Aplicar? |
|------------------|---------------|------------------|------|---------|-------------|-----------|
| `_________` | `_________` | `_________` | +___ | -___% | +___% | [ ] Sí [ ] No |

**Justificación (obligatoria para cada cambio marcado "Sí"):**

> Ejemplo: Oracle pasa de GLM-5.1 a Kimi-K2.6 porque +3 IQ (54 vs 51) y -73% costo ($0.58 vs $2.15) en Go.

---

## Paso 6: Validar Impacto de Fallbacks

Si cambias un modelo, verifica que la cadena de fallbacks siga lógica:

```
Ejemplo: Oracle (kimi-k2.6) falla → deepseek-v4-pro → qwen3.6-plus
¿deepseek-v4-pro sigue siendo el mejor fallback disponible? □ Sí □ No
```

Regla: los fallbacks deben **degradar inteligencia gradualmente**, no saltar al azar.

---

## Paso 7: Aplicar Cambios Aprobados

```bash
# 1. Editar JSON
nano opencode-go/oh-my-openagent.json

# 2. Validar sintaxis
python3 -m json.tool opencode-go/oh-my-openagent.json > /dev/null && echo "✅ JSON válido"

# 3. Determinar nueva versión SemVer
#    - v1.1.0 → v1.2.0: cambio significativo de modelos (varios agentes)
#    - v1.1.0 → v1.1.1: fix menor (un solo modelo, typo, fallback)
#    - v1.1.0 → v2.0.0: cambio de provider o filosofía general

# 4. Actualizar opencode-go/docs/changelog-config.md
#    Añadir entrada con fecha, cambios, justificación y rollback

# 5. Commit y tag
git add -A
git commit -m "optimize: [breve descripción] vX.Y.Z

- Agente: modelo_antiguo → modelo_nuevo
- Rationale: artificialanalysis.ai + opencode.ai/docs/go
- Impacto: +X IQ, -Y% costo"
git tag -a vX.Y.Z -m "[descripción de la optimización]"

# 6. Deploy en producción
./setup.sh opencode-go

# 7. Publicar
git push origin main
git push origin vX.Y.Z
```

---

## Paso 8: Observación Post-Cambio (48h)

- [ ] ¿Sisyphus orquesta sin errores?
- [ ] ¿Los agentes de implementación (Hephaestus/Atlas) responden más rápido?
- [ ] ¿El costo por hora de trabajo bajó?
- [ ] ¿Algún fallback se activó más de lo normal? (indica que el modelo nuevo es menos estable)

**Si algo falla, rollback inmediato:**
```bash
git checkout vVERSION-ANTERIOR -- opencode-go/oh-my-openagent.json
./setup.sh opencode-go
```

---

## Historial de Auditorías

| Fecha | Versión | Auditor | Cambios Aplicados | Resultado |
|-------|---------|---------|-------------------|-----------|
| 2026-05-11 | v1.0.0 → v1.1.0 | Sisyphus (AI) | Oracle/Prometheus/Ultrabrain → Kimi; Hephaestus/Atlas → V4-Flash; Multimodal → Qwen | ✅ Éxito |
| _______ | _______ | _______ | _______ | _______ |
