# Ejemplo de Sesión: Investigación de Fallbacks

> Caso de uso real donde el tiered routing funcionó correctamente.
> Fecha: 2026-05-08

## Contexto

El usuario quería verificar que su configuración de Oh My OpenAgent con OpenCode Go estaba funcionando correctamente, específicamente:

1. Que los fallbacks no usaban modelos de pago de Zen
2. Que cada agente usaba su modelo asignado al delegar tareas
3. Que el tiered routing se aplicaba en la práctica

## Sesión en OpenChamber (Web)

### Prompt inicial

> "Investiga cómo funciona el sistema de fallbacks de Oh My OpenAgent y dime si mi configuración está optimizada"

### Flujo de agentes activados

```
Sisyphus (kimi-k2.6)
    │
    ├──► Librarian (deepseek-v4-flash)
    │       └── Busca documentación oficial
    │       └── Lee código fuente del plugin
    │
    ├──► Oracle (glm-5.1)
    │       └── Analiza arquitectura técnica
    │       └── Interpreta código de resolución
    │
    └──► Sisyphus (kimi-k2.6)
            └── Síntesis final para el usuario
```

### Evidencia de logs

#### Sisyphus (agente principal)

```log
INFO  service=llm providerID=opencode-go modelID=kimi-k2.6 
      session.id=ses_1f8f36d46ffe7XVqhDfC0Yc1se 
      agent=Sisyphus - Ultraworker 
      mode=primary
```

#### Librarian (delegado para research)

```log
INFO  service=llm providerID=opencode-go modelID=deepseek-v4-flash 
      session.id=ses_1f83d9d8fffeaBSWpVN5zahaIc 
      agent=librarian 
      mode=subagent
```

#### Oracle (delegado para análisis)

Nota: Oracle también se activó en la tarea de fondo para análisis técnico profundo.

---

## Qué se validó

### 1. Zen desconectado por defecto

```bash
$ opencode auth list
●  OpenCode Go  [api]
```

✅ Solo Go estaba conectado. Zen no aparecía.

### 2. Cero referencias a Zen en config

```bash
$ grep -c "opencode-zen" ~/.config/opencode/oh-my-openagent.json
0
```

✅ El JSON no tenía modelos de Zen.

### 3. Tiered routing funcionó

| Agente | Modelo configurado | Modelo usado (logs) | Tier |
|---|---|---|---|
| Sisyphus | `kimi-k2.6` | `kimi-k2.6` | 3 Élite |
| Librarian | `deepseek-v4-flash` | `deepseek-v4-flash` | 1 Volumen |

✅ Librarian usó su modelo asignado, NO heredó `kimi-k2.6` de Sisyphus.

### 4. Librarian fue el agente correcto

La tarea era pura investigación (buscar docs, leer código). No era implementación, planning, ni review.

| Si se hubiera delegado a... | Resultado |
|---|---|
| Hephaestus | ❌ Hubiera intentado implementar algo |
| Prometheus | ⚠️ Hubiera creado un plan, no la investigación |
| Oracle | ✅ También válido, pero más costoso |
| Explore | ⚠️ Solo grep rápido, sin análisis |
| **Librarian** | ✅ **Correcto: research + documentación** |

---

## Lecciones de esta sesión

### Para el usuario

1. **No todo necesita K2.6**: Una tarea de research con Librarian (V4 Flash) es 10x más barata y suficiente
2. **Los logs no mienten**: `~/.local/share/opencode/log/` confirma qué modelo usó cada agente
3. **Zen está seguro**: Desconectado por defecto, solo se conecta manualmente

### Para quien replica esta config

1. **Verificar después de instalar**: Correr la checklist de `verification.md`
2. **No asumir que funciona**: Los logs son la única prueba real de que el routing es correcto
3. **Documentar tu primera sesión**: Guarda los logs de una sesión real como evidencia

---

## Datos de uso reales (sesión de configuración)

Esta sesión (configuración del repo, investigación, documentación) duró aproximadamente 3-4 horas.

### Distribución real del coste

| Modelo | Coste observado | Porcentaje | Interpretación |
|---|---|---|---|
| **V4 Flash** | ~$6.00 USD | ~92% | Volumen masivo: búsquedas, grep, tareas simples |
| **V4 Pro** | ~$0.50 USD | ~7% | Implementación estándar |
| **K2.6** | ~$0.50 USD | ~1% | Orchestración y decisiones críticas |

### Lo que confirman estos números

**V4 Flash costó 12x más dinero que K2.6, pero procesó ~150x más requests.**

```
Estimación de requests:
• V4 Flash: ~30,000 requests × $0.0002 = $6.00
• V4 Pro:   ~   200 requests × $0.0025 = $0.50
• K2.6:     ~   200 requests × $0.0025 = $0.50
```

**Conclusión:** El 92% del trabajo se hizo con el modelo más barato (V4 Flash). Solo el 1% requirió orquestación de élite (K2.6). Esto es exactamente lo que debe pasar con un tiered routing correcto.

### Comparativa: ¿Qué pasaría sin tiered routing?

| Estrategia | Coste estimado de esta sesión | ¿Sostenible? |
|---|---|---|
| **Todo con K2.6** | ~$30 USD | ❌ Agotarías presupuesto en 2 días |
| **Todo con V4 Pro** | ~$12 USD | ⚠️ Consume ventana de 5h de golpe |
| **Tiered routing (esta config)** | ~$6.50 USD | ✅ Sostenible para trabajo diario |

**Ahorro real: ~78% vs. usar solo K2.6.**

---

## Comandos usados en esta sesión

```bash
# Verificar auth
opencode auth list

# Verificar modelos disponibles
opencode models opencode-go

# Validar JSON
python3 -m json.tool ~/.config/opencode/oh-my-openagent.json > /dev/null

# Buscar en logs
ls -lt ~/.local/share/opencode/log/ | head -3
grep "agent=Sisyphus" ~/.local/share/opencode/log/TIMESTAMP.log
grep "agent=librarian" ~/.local/share/opencode/log/TIMESTAMP.log
```
