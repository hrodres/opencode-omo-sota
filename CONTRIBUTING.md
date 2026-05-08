# Contributing to opencode-omo-sota

> Cómo añadir presets, reportar issues, y mejorar la documentación.

## Cómo añadir un nuevo preset

### 1. Estructura del preset

Cada preset va en su propia carpeta al nivel raíz:

```
opencode-omo-sota/
├── opencode-go/
├── tu-preset/           # ← Nueva carpeta
│   ├── oh-my-openagent.json
│   ├── PROMPT.md
│   └── README.md
```

### 2. Requisitos mínimos

Cada preset debe incluir:

- **`oh-my-openagent.json`**: Configuración operativa completa y validada
- **`PROMPT.md`**: Instrucciones para recrear/actualizar la configuración
- **`README.md`**: Guía específica del plan con:
  - Qué incluye el plan (precio, modelos)
  - Instalación (manual o via `setup.sh`)
  - Arquitectura por tiers
  - FAQ (basada en problemas reales)
  - Troubleshooting

### 3. Convenciones

- **Modelos**: Usar prefijo explícito (`opencode-go/`, `opencode-zen/`, `openai/`, etc.)
- **Fallbacks**: Nunca mezclar planes de pago sin avisar al usuario
- **Auth**: Documentar claramente qué proveedores deben estar conectados
- **Commits**: Usar [Conventional Commits](https://www.conventionalcommits.org/)
  - `feat:` para nuevos presets o features
  - `docs:` para documentación
  - `fix:` para correcciones

### 4. Testing antes de PR

Antes de enviar un PR:

```bash
# 1. Validar JSON
python3 -m json.tool tu-preset/oh-my-openagent.json > /dev/null

# 2. Verificar que no haya modelos obsoletos
opencode models TU-PROVIDER

# 3. Revisar que el setup.sh detecte el preset
./setup.sh tu-preset

# 4. Actualizar README.md raíz si añades un preset nuevo
```

## Cómo reportar un issue

Usa GitHub Issues con este formato:

```
**Preset:** opencode-go (o el que corresponda)
**Problema:** Breve descripción
**Logs:** Relevantes de ~/.local/share/opencode/log/
**Config:** Versión del JSON (fecha o commit)
**Pasos para reproducir:**
1. ...
2. ...
```

## Cómo mejorar documentación

- **READMEs**: Mantener concisos pero completos
- **FAQ**: Añadir solo preguntas reales que alguien haya hecho
- **Session examples**: Incluir logs reales como evidencia
- **Architecture**: Actualizar si cambia el stack

## Licencia

Al contribuir, aceptas que tu trabajo se publique bajo [MIT License](LICENSE).
