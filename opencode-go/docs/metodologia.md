# oh-my-openagent — Metodologia de Uso

> Calibrado para el preset `opencode-go` (100% Go, sin OpenAI).
> Para detalles tecnicos de la configuracion de modelos, ver `changelog-config.md`.

---

## Tu setup: LXC + OpenCode + omo + OpenCode Go + OpenChamber web

100% OpenCode Go sin OpenAI. OpenChamber via web funciona perfectamente.
Consulta `oh-my-openagent.commented.json` para proposito de cada agente y categoria.

---

## Cuando usar cada modo

### ulw — Tarea de codigo concreta y bien definida

```
ulw añade validacion al endpoint de login en auth/routes.py
```

Sisyphus entra en modo autonomo: delega a Junior, usa explore/librarian, no para hasta terminar.
Modo mas eficiente en quota por resultado.

**Background agents en paralelo:** omo ejecuta simultaneamente mientras Junior implementa.
Explore busca patrones, Librarian consulta docs. Esto explica agotamiento rapido de quota
— es normal, es el sistema funcionando correctamente.

**Ralph Loop — Tareas muy largas:**
```
/ulw-loop
```
Fuerza ejecucion hasta que todos los TODOs esten al 100%.

---

### Prometheus — Tarea compleja con incertidumbre

**Opcion A — desde Sisyphus:**
```
@plan "descripcion de la tarea"
```

**Opcion B — cambio de agente:**
```
Tab → Prometheus → describe la tarea
```

Prometheus entrevista, identifica alcance, genera plan detallado.
Cuando este listo: `/start-work`

El plan persiste en `.sisyphus/plans/` entre sesiones.

---

### task(category="chat") — Pregunta rapida o exploracion

```
task(category="chat") tu pregunta
```

Usa deepseek-v4-flash (barato). Para preguntas sin implementacion.
Alternativa: chat externo para no consumir quota Go.

**Critico:** No uses Sisyphus como chat. Consume kimi-k2.6 rapidamente.
Si llevas 3+ mensajes sin codigo, cambia a este modo o Prometheus.

---

### Explore/Librarian — Exploracion del codebase

```
Tab → Explore
```

Busqueda rapida de patrones, ficheros, referencias, documentacion.
Flash = instantaneo y barato.

---

### Sisyphus directo sin ulw — Fix simple, fichero unico

```
"arregla el bug en linea 42 de auth.py"
```

Solo si es realmente trivial. Mas de un intercambio → activa `ulw`.

---

## Senales de modo equivocado

- **3+ mensajes sin codigo** → Prometheus o chat externo
- **Sisyphus implementa en vez de delegar** → usa `ulw`
- **Quota se agota rapido** → conversacion con Sisyphus en lugar de `ulw`
- **Dudas sobre que hacer** → `/init-deep` o Prometheus, no conversacion

---

## Contexto entre sesiones

### /init-deep — Recomendado para proyectos

```
/init-deep
```

Genera `AGENTS.md` jerarquicos:
```
project/
├── AGENTS.md              ← general
├── src/AGENTS.md          ← especifico
└── components/AGENTS.md   ← detallado
```

Sisyphus lee automaticamente el contexto relevante por directorio.
Actualiza cuando tomes decisiones importantes.

Escalable, mantenible, la mejor opcion para proyectos reales.

---

### .sisyphus/ — Auditoria del aprendizaje

```bash
find .sisyphus/ -type f | sort
cat .sisyphus/notepads/*/learnings.md
cat .sisyphus/notepads/*/decisions.md
```

Ver wisdom acumulado. Util para debugging, menos escalable que /init-deep.

---

## Regla central

**La quota se agota cuando usas Sisyphus como chat.**

Patrones correctos por objetivo:
- Conversacion → chat externo o `task(category="chat")`
- Tarea concreta → `ulw [descripcion]`
- Tarea compleja → `@plan` o Prometheus → `/start-work`

Este patron es la diferencia mas grande en consumo de quota.

---

## Limitaciones de tu setup

**Hephaestus:** Diseñado para GPT-5.5, degradado a deepseek-v4-pro en Go.
Funcional con limitaciones. Para razonamiento profundo, `ulw` con Sisyphus es mejor.

**Sin OpenAI/Google:** Sin GPT-5.5, sin Gemini. Los fallbacks son Go-only.
Sustitutos optimizados pero no equivalentes.

**Sin Team Mode:** Requiere tmux. OpenChamber web no lo soporta. No relevante actualmente.

---

## Versionado

Este documento corresponde al preset `opencode-go` **v1.3.x**.
Si se añaden presets adicionales (Zen, ChatGPT Plus), la metodologia debera adaptarse.
