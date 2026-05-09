# Modos de trabajo en Oh My OpenAgent

OMO define tres niveles de interacción según la complejidad de la tarea. Usar el modo correcto ahorra costes y mejora resultados.

---

## 1. Modo Simple: Prompt directo

**Cuándo usar:** Tareas rápidas, fixes de un archivo, cambios triviales.

**Ejemplos:**
- "Arregla el typo en `utils.py` línea 23"
- "Añade un log en esta función"
- "Renombra esta variable a `userCount`"

**Cómo:** Escribe el prompt normalmente. OMO usará el agente por defecto (Sisyphus) con el modelo configurado.

**Coste:** Mínimo. Suele resolver en 1-3 requests de Tier 1 o 2.

---

## 2. Modo Ultrawork: `ultrawork` o `ulw`

**Cuándo usar:** Tareas complejas donde explicar todo el contexto es tedioso. El agente descubre el código, la estructura y los patrones por sí mismo.

**Ejemplos:**
- "Implementa autenticación JWT en la API"
- "Refactoriza este módulo para usar async/await"
- "Añade tests unitarios a todo el paquete `auth/`"

**Cómo:** Escribe `ultrawork` (o `ulw`) seguido de una descripción breve de la tarea.

```
ultrawork
Implementa rate limiting en la API usando Redis. Debe soportar burst y limitar por IP y por user ID.
```

**Qué hace OMO:**
1. Explora el codebase para entender la estructura
2. Investiga patrones existentes
3. Implementa la feature
4. Verifica con tests/diagnósticos
5. Itera hasta completar

**Coste:** Medio. Puede consumir 50-200 requests dependiendo de la complejidad.

---

## 3. Modo Preciso: `@plan` → `/start-work`

**Cuándo usar:** Trabajo multi-paso que requiere orquestación real, con planificación explícita y verificación rigurosa.

**Ejemplos:**
- "Migra todo el proyecto de REST a GraphQL con tests y documentación"
- "Implementa un nuevo motor de búsqueda con Elasticsearch, indexación y UI"
- "Refactoriza la arquitectura de monolito a microservicios"

**Cómo:**
1. Escribe `@plan` para entrar en modo Prometheus
2. Prometheus entrevista para definir alcance
3. Genera un plan en `.sisyphus/plans/*.md`
4. Ejecuta `/start-work` para que Atlas orqueste la ejecución

**Flujo:**
```
@plan
Necesito migrar la API de REST a GraphQL

[Prometheus entrevista...]

Plan generado: .sisyphus/plans/graphql-migration.md

/start-work
```

**Qué hace OMO:**
1. **Prometheus** entrevista para definir alcance exacto
2. **Metis** consulta sobre gaps y ambigüedades
3. **Momus** revisa el plan para calidad y completitud
4. **Atlas** orquesta la ejecución con todos los agentes especializados
5. Verificación continua en cada paso

**Coste:** Alto. Puede consumir 200-1000+ requests en sesiones largas, pero con máxima precisión y verificación.

---

## Tabla comparativa

| | Modo Simple | Modo Ultrawork | Modo Preciso |
|---|---|---|---|
| **Complejidad** | Baja | Media-Alta | Alta |
| **Contexto** | Tú lo proporcionas | El agente lo descubre | Definido en plan |
| **Planificación** | Ninguna | Implícita | Explícita (Prometheus) |
| **Verificación** | Básica | Automática | Rigurosa (Atlas) |
| **Coste** | $ | $$ | $$$ |
| **Comando** | Prompt normal | `ultrawork` | `@plan` → `/start-work` |

---

## Regla de oro

> **Si es un quick fix → Modo Simple.**
> **Si es una feature y explicar todo es pesado → Modo Ultrawork.**
> **Si es un proyecto grande que no puede fallar → Modo Preciso.**

Usar Ultrawork para un typo es desperdiciar dinero. Usar un prompt simple para una migración arquitectónica es pedir problemas.
