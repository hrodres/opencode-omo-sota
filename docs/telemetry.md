# Telemetría en Oh My OpenAgent

Oh My OpenAgent envía telemetría anónima por defecto. Esta página explica qué se recopila, por qué, y cómo desactivarla.

---

## ¿Qué se recopila?

OMO utiliza PostHog para telemetría anónima con los siguientes límites:

| Dato | ¿Se recopila? | Notas |
|---|---|---|
| **Instalaciones activas** | Sí | DAU/WAU/MAU (usuarios diarios/semanales/mensuales) |
| **Eventos** | Sí | Un único evento por día como máximo |
| **Identificador** | Hasheado | Identificador de instalación hasheado, no vinculable |
| **Perfiles de usuario** | No | PostHog person profiles están desactivados |
| **Código fuente** | No | Nunca se envía código |
| **Prompts** | No | Nunca se envían conversaciones |
| **Modelos usados** | No | No se trackean requests individuales |

---

## ¿Por qué existe?

La telemetría ayuda a los mantenedores de OMO a:
- Entender cuántas personas usan la herramienta
- Priorizar desarrollo de features
- Detectar problemas de instalación

Es una práctica estándar en proyectos open-source.

---

## Cómo desactivarla

### Opción A: Variable de entorno (recomendada)

Añade a tu `~/.bashrc`, `~/.zshrc`, o archivo de shell equivalente:

```bash
export OMO_SEND_ANONYMOUS_TELEMETRY=0
```

O alternativamente:

```bash
export OMO_DISABLE_POSTHOG=1
```

Reinicia tu terminal o ejecuta `source ~/.bashrc` (o `~/.zshrc`) para aplicar.

### Opción B: Script de setup automático

Si usas el `setup.sh` de este repositorio, te preguntará automáticamente si deseas desactivar la telemetría al final de la instalación.

### Verificación

Para confirmar que está desactivada:

```bash
echo $OMO_SEND_ANONYMOUS_TELEMETRY
# Debe mostrar: 0
```

---

## Notas legales

- La telemetría cumple con el [Privacy Policy](https://ohmyopenagent.com/legal/privacy-policy) de OMO
- No se venden ni comparten datos con terceros
- El identificador es un hash unidireccional (no reversible)

Para más detalles técnicos, consulta la [documentación oficial de OMO](https://ohmyopenagent.com/docs).
