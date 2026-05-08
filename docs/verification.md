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

## 3. Modelos disponibles

```bash
opencode models opencode-go
```

**Verificar que existen** los modelos configurados:
- `kimi-k2.6`
- `deepseek-v4-pro`
- `deepseek-v4-flash`
- `glm-5.1`
- `qwen3.6-plus`
- `qwen3.5-plus`
- `mimo-v2.5`

Si alguno falta, buscar el equivalente del mismo tier y actualizar el JSON.

---

## 4. Tiered Routing funciona (logs)

### 4.1 Encontrar el log de tu sesión actual

```bash
ls -lt ~/.local/share/opencode/log/ | head -3
```

### 4.2 Verificar que Sisyphus usa kimi-k2.6

```bash
grep "agent=Sisyphus" ~/.local/share/opencode/log/TIMESTAMP.log | head -3
```

**Esperado:**
```
providerID=opencode-go modelID=kimi-k2.6 agent=Sisyphus
```

### 4.3 Verificar que otros agentes usan sus modelos

Delegar una tarea de investigación y verificar:

```bash
# Después de delegar a Librarian:
grep "agent=librarian" ~/.local/share/opencode/log/TIMESTAMP.log | head -3

# Esperado: providerID=opencode-go modelID=deepseek-v4-flash agent=librarian
```

**Si todos los agentes usan `kimi-k2.6`:** Revisar que el plugin OMO está cargado:
```bash
cat ~/.config/opencode/opencode.json
# Debe contener: { "plugin": ["oh-my-openagent@latest"] }
```

---

## 5. Rate limits y fallbacks

### 5.1 Verificar cooldown activo

Si un modelo da rate limit, buscar en logs:
```bash
grep -i "cooldown\|blacklist\|fallback" ~/.local/share/opencode/log/TIMESTAMP.log | tail -10
```

**Esperado:**
```
provider opencode-go/kimi-k2.6 blacklisted for 60s
fallback to opencode-go/deepseek-v4-pro
```

### 5.2 Verificar concurrencia

```bash
grep "defaultConcurrency\|modelConcurrency" ~/.config/opencode/oh-my-openagent.json
```

**Valores recomendados:**
- `kimi-k2.6`: 2
- `deepseek-v4-pro`: 3
- `deepseek-v4-flash`: 20
- `glm-5.1`: 1

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
- [ ] Logs muestran `kimi-k2.6` para Sisyphus
- [ ] Logs muestran `deepseek-v4-flash` para Librarian (al delegar)
- [ ] Plugin cargado en `opencode.json`
- [ ] Sin errores de `opencode-zen` en fallbacks

---

## Si algo falla

1. **Validar JSON primero** (errores de sintaxis son la causa #1)
2. **Reiniciar servidor**: `pkill -f "opencode serve" && opencode serve &`
3. **Verificar auth**: Zen conectado accidentalmente puede overridear routing
4. **Consultar logs**: `~/.local/share/opencode/log/` tienen timestamps precisos
5. **Usar `opencode debug config`** si está disponible
