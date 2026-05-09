# Verificación Post-Configuración

> Checklist para validar que tu configuración de Oh My OpenAgent con OpenCode Go está funcionando correctamente.

## Antes de empezar

Asegúrate de que:
- El servidor `opencode serve` está corriendo
- Estás conectado desde OpenChamber (web)
- Has copiado tu `oh-my-openagent.json` a `~/.config/opencode/`

---

## 1. Autenticación

```bash
opencode auth list
```

**Esperado:**
```
●  OpenCode Go  [api]
```

**Si ves Zen conectado y no lo quieres:**
```bash
# Opción A: Desconectar editando auth.json
# Quitar la entrada "opencode" de ~/.local/share/opencode/auth.json

# Opción B: Reconectar Zen bajo demanda (temporal)
opencode auth login
# Usar modelo Zen manualmente
# Desconectar al terminar editando auth.json
```

---

## 2. Configuración JSON válida

```bash
python3 -m json.tool ~/.config/opencode/oh-my-openagent.json > /dev/null && echo "✅ Válido" || echo "❌ Inválido"
```

**Verificar también:**
```bash
grep -c "opencode-go/" ~/.config/opencode/oh-my-openagent.json  # Debe ser > 0
grep -c "opencode-zen\|opencode/claude\|opencode/gpt-5\.5" ~/.config/opencode/oh-my-openagent.json  # Debe ser 0
```

---

## 3. Verificar salud de OMO (opcional pero recomendado)

Si tienes el CLI de OMO disponible:

```bash
# Ruta típica en instalaciones por plugin
/root/.cache/opencode/packages/oh-my-openagent@latest/node_modules/.bin/oh-my-openagent doctor
```

**Esperado:**
- ✅ Oh My OpenAgent instalado
- ✅ OpenCode versión compatible
- ⚠️ Posible warning sobre algún modelo del Tier 3 (modelo disponible en Go pero no catalogado aún en models.dev)
- ⚠️ Posible warning sobre LSP/GitHub CLI (no crítico para Go-Only)

Si hay warnings sobre modelos desconocidos, actualiza el cache:
```bash
/root/.cache/opencode/packages/oh-my-openagent@latest/node_modules/.bin/oh-my-openagent refresh-model-capabilities
```

---

## 4. Modelos disponibles

```bash
opencode models opencode-go
```

**Verificar que existen** los modelos configurados en `~/.config/opencode/oh-my-openagent.json`:

```bash
grep -oE 'opencode-go/[a-z0-9.-]+' ~/.config/opencode/oh-my-openagent.json | sort -u
```

Compara esta lista con la salida de `opencode models opencode-go`. Si alguno falta, busca el equivalente del mismo tier y actualiza el JSON (ver [`PROMPT.md`](../opencode-go/PROMPT.md) para el proceso).

---

## 5. Tiered Routing funciona (logs)

### 4.1 Encontrar el log de tu sesión actual

```bash
ls -lt ~/.local/share/opencode/log/ | head -3
```

### 5.2 Verificar que Sisyphus usa su modelo asignado

```bash
grep "agent=Sisyphus" ~/.local/share/opencode/log/TIMESTAMP.log | head -3
```

**Esperado:**
```
providerID=opencode-go modelID=<tier-3-model> agent=Sisyphus
```

(El modelo exacto está en `oh-my-openagent.json`, típicamente Tier 3)

### 5.3 Verificar que otros agentes usan sus modelos asignados

Delegar una tarea de investigación y verificar:

```bash
# Después de delegar a Librarian:
grep "agent=librarian" ~/.local/share/opencode/log/TIMESTAMP.log | head -3

# Esperado: providerID=opencode-go modelID=<tier-1-model> agent=librarian
```

**Si todos los agentes usan el mismo modelo (ej. Tier 3):** Revisar que el plugin OMO está cargado:
```bash
cat ~/.config/opencode/opencode.json
# Debe contener: { "plugin": ["oh-my-openagent@latest"] }
```

---

## 6. Rate limits y fallbacks

### 6.1 Verificar cooldown activo

Si un modelo da rate limit, buscar en logs:
```bash
grep -i "cooldown\|blacklist\|fallback" ~/.local/share/opencode/log/TIMESTAMP.log | tail -10
```

**Esperado:**
```
provider opencode-go/<model> blacklisted for 60s
fallback to opencode-go/<fallback-model>
```

### 6.2 Verificar concurrencia

```bash
grep "defaultConcurrency\|modelConcurrency" ~/.config/opencode/oh-my-openagent.json
```

**Valores recomendados:** Ver `oh-my-openagent.json`. En general:
- Tier 3 (élite): 1-2
- Tier 2 (estándar): 3-5
- Tier 1 (volumen): 10-20

---

## 6. Plugin cargado correctamente

```bash
grep "oh-my-openagent" ~/.config/opencode/opencode.json
```

**Esperado:**
```json
{ "plugin": ["oh-my-openagent@latest"] }
```

Si aparece `"oh-my-opencode"` (nombre antiguo), también funciona pero genera un warning.

---

## Checklist rápido

- [ ] `opencode auth list` → Solo Go conectado
- [ ] JSON válido (`python3 -m json.tool`)
- [ ] Todos los modelos configurados existen en `opencode models opencode-go`
- [ ] Logs muestran Tier 3 para Sisyphus
- [ ] Logs muestran Tier 1 para Librarian (al delegar)
- [ ] Plugin cargado en `opencode.json`
- [ ] Sin errores de `opencode-zen` en fallbacks

---

## Si algo falla

1. **Validar JSON primero** (errores de sintaxis son la causa #1)
2. **Reiniciar servidor**: `pkill -f "opencode serve" && opencode serve &`
3. **Verificar auth**: Zen conectado accidentalmente puede overridear routing
4. **Consultar logs**: `~/.local/share/opencode/log/` tienen timestamps precisos
5. **Usar `opencode debug config`** si está disponible
