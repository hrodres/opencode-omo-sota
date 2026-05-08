# Arquitectura del Stack

> Cómo encajan todas las piezas de este sistema.

## Diagrama General

```
┌─────────────────────────────────────────────────────────────────┐
│                         TÚ (Dispositivo)                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │  Laptop     │  │  Smartphone │  │  Cualquier navegador    │  │
│  │  (Windows)  │  │  (Android)  │  │  con acceso web         │  │
│  └──────┬──────┘  └──────┬──────┘  └────────────┬────────────┘  │
│         │                │                      │                │
│         └────────────────┴──────────────────────┘                │
│                          │                                       │
│                    HTTPS/WebSocket                               │
│                          │                                       │
└──────────────────────────┼───────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SERVIDOR LXC (Backend)                        │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  OpenCode Server                                        │   │
│  │  ├─ opencode serve (puerto 37915)                       │   │
│  │  ├─ oh-my-openagent (plugin)                            │   │
│  │  ├─ oh-my-openagent.json (configuración)                │   │
│  │  └─ LSP servers (typescript, python, etc.)              │   │
│  │                                                         │   │
│  │  Modelos disponibles:                                   │   │
│  │  ├─ Tier 1: deepseek-v4-flash (31K req/5h)              │   │
│  │  ├─ Tier 2: deepseek-v4-pro, qwen3.6-plus (~3K req/5h)  │   │
│  │  └─ Tier 3: kimi-k2.6, glm-5.1 (~1K req/5h)            │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Autenticación                                          │   │
│  │  ├─ OpenCode Go: Conectado (suscripción $10/mes)        │   │
│  │  └─ OpenCode Zen: Desconectado por defecto              │   │
│  │     (solo se conecta manualmente bajo demanda)          │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Proyectos de trabajo                                   │   │
│  │  └─ /root/workspace/ (o tu directorio de trabajo)       │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Piezas del sistema

### 1. OpenChamber (Frontend Web)

**Qué es:** Interfaz web para interactuar con OpenCode.

**Por qué se usa aquí:**
- El cliente desktop de OpenCode solo está disponible para **macOS**
- Este stack corre en **Windows/Linux**, por lo que el cliente desktop no es opción
- OpenChamber permite acceder desde **cualquier dispositivo con navegador**:
  - Laptop con Windows
  - Smartphone (Android/iOS)
  - Tablet
  - Cualquier otra máquina

**Ventaja clave:** Puedes empezar una sesión en tu laptop y continuarla en tu smartphone sin perder contexto.

**Limitación:** Requiere que el servidor LXC sea accesible desde la red donde te conectes.

### 2. LXC (Infraestructura)

**Qué es:** Contenedor Linux aislado donde corre todo el backend.

**Por qué LXC y no Docker:**
- Más ligero que Docker para un solo servicio persistente
- Estado persistente sin volúmenes complejos
- Fácil de snapshotear y migrar
- Ideal para un servidor personal que está siempre encendido

**Qué corre dentro:**
- OpenCode server (`opencode serve`)
- Plugin Oh My OpenAgent
- Archivos de configuración (`~/.config/opencode/`)
- Logs y caché (`~/.local/share/opencode/`)
- Proyectos de trabajo

### 3. Oh My OpenAgent (Orquestación)

**Qué es:** Plugin que transforma OpenCode en un equipo de agentes especializados.

**Qué hace:**
- Rutifica tareas al agente adecuado (Sisyphus, Librarian, Oracle, etc.)
- Asigna modelos según tier (Flash → Pro → Élite)
- Gestiona fallbacks cuando un modelo da rate limit
- Coordina ejecución paralela de agentes

**Configuración clave:**
- `oh-my-openagent.json`: Define modelos, fallbacks, concurrencia
- Cada agente tiene su modelo asignado del plan Go
- Zen está desconectado por defecto

### 4. OpenCode Go (Modelos)

**Qué es:** Plan de suscripción de $10/mes con acceso a modelos open-source SOTA.

**Modelos disponibles:**
- **Tier 1 (Volumen):** `deepseek-v4-flash`, `qwen3.5-plus`, `minimax-m2.5`
- **Tier 2 (Estándar):** `deepseek-v4-pro`, `qwen3.6-plus`, `minimax-m2.7`
- **Tier 3 (Élite):** `kimi-k2.6`, `glm-5.1`, `mimo-v2.5`

**Filosofía:** Usar el modelo adecuado para cada tarea, no el más caro para todo.

### 5. OpenCode Zen (Opcional)

**Qué es:** API de pago con acceso a modelos frontier (Claude Opus, GPT-5.5, Gemini-3.1 Pro).

**Estado:** Desconectado por defecto.

**Cuándo usarlo:**
- Tareas de arquitectura crítica donde los 6 puntos de diferencia en SWE-Pro importan
- Incidentes de producción donde cada minuto cuenta
- Tecnologías muy nuevas o poco documentadas
- Cuando el usuario decide explícitamente que vale la pena el coste

**Cómo conectarlo:**
```bash
opencode auth login
# Seleccionar Zen
# Usar modelo Zen manualmente
# Desconectar al terminar editando auth.json
```

---

## Flujo de trabajo típico

### Escenario: Implementar una nueva feature

1. **Tú** escribes en OpenChamber (web):
   > "Implementa autenticación OAuth2 en el backend"

2. **Sisyphus (K2.6)** analiza la petición y decide delegar:
   - A **Prometheus (GLM-5.1)** → Crear plan detallado
   - A **Explore (V4 Flash)** → Buscar archivos existentes relacionados

3. **Prometheus** devuelve un plan de 5 pasos

4. **Sisyphus** delega a **Hephaestus (V4 Pro)** → Implementar los cambios de código

5. **Hephaestus** edita archivos, ejecuta tests

6. **Sisyphus** delega a **Code-reviewer (K2.6)** → Revisar calidad del código

7. **Sisyphus** te presenta el resultado final

### Coste de esta sesión:

- Prometheus (GLM-5.1): ~10 requests → $0.15
- Explore (V4 Flash): ~50 requests → $0.10
- Hephaestus (V4 Pro): ~80 requests → $1.20
- Code-reviewer (K2.6): ~20 requests → $0.80
- Sisyphus (K2.6): ~15 requests → $0.60

**Total: ~$2.85** de tu presupuesto de $12/5h.

Si todo hubiera corrido con K2.6: **~$8.50** (3x más caro).

---

## Terminal vs. OpenChamber

### ¿Cuándo se usa la terminal?

La terminal (acceso SSH al LXC) se usa para:
- **Instalación** de OpenCode, plugins, dependencias
- **Configuración** del sistema (auth, ajustes del servidor)
- **Debugging** avanzado (logs, procesos, red)
- **Mantenimiento** (actualizaciones, backups)

**Ejemplos:**
```bash
# Instalación
bunx oh-my-openagent install

# Configuración
opencode auth login

# Debugging
grep "rate limit" ~/.local/share/opencode/log/latest.log

# Mantenimiento
apt update && apt upgrade
```

### ¿Cuándo se usa OpenChamber?

OpenChamber (web) se usa para:
- **Trabajo diario** con proyectos (coding, review, debugging)
- **Sesiones interactivas** largas (múltiples iteraciones)
- **Acceso desde cualquier dispositivo** (laptop, smartphone, tablet)
- **Continuidad** (empezar en laptop, continuar en smartphone)

**Ejemplos:**
- "Refactoriza este módulo de autenticación"
- "Encuentra todos los usos de esta función"
- "Review este PR y dime qué mejorar"
- "Implementa tests para este componente"

### ¿Por qué esta separación?

| Tarea | Terminal | OpenChamber |
|---|---|---|
| Instalar software | ✅ | ❌ |
| Configurar auth | ✅ | ❌ |
| Leer logs | ✅ | ❌ |
| Codear feature | ❌ | ✅ |
| Review código | ❌ | ✅ |
| Debug interactivo | ⚠️ Limitado | ✅ Rico |
| Desde smartphone | ❌ | ✅ |

---

## Consideraciones de red

### Acceso desde fuera de la red local

Si tu LXC está en casa y quieres acceder desde fuera:

**Opción A: VPN**
```
[Tú en cafetería] ──VPN──► [Router casa] ──► [LXC]
```
Seguro, pero requiere configurar VPN en cada dispositivo.

**Opción B: Túnel inverso (ngrok/cloudflare)**
```
[LXC] ──túnel──► [Servidor intermedio] ──► [Tú]
```
Más fácil, pero depende de servicio externo.

**Opción C: VPS en la nube**
```
[Tú] ──Internet──► [VPS/LXC en cloud] ──► [LXC]
```
Siempre accesible, pero tiene coste mensual.

### Seguridad

- El servidor `opencode serve` escucha en `127.0.0.1` por defecto
- Para acceso remoto, considerar:
  - Autenticación por contraseña (`--password`)
  - HTTPS/TLS
  - Firewall restrictivo
  - VPN siempre que sea posible

---

## Troubleshooting de arquitectura

### "No puedo conectar OpenChamber al servidor"

1. Verificar que `opencode serve` está corriendo:
   ```bash
   ps aux | grep "opencode serve"
   ```

2. Verificar puerto y hostname:
   ```bash
   netstat -tlnp | grep 37915
   ```

3. Verificar firewall:
   ```bash
   iptables -L | grep 37915
   ```

4. Probar conexión desde tu máquina:
   ```bash
   curl http://IP_DEL_LXC:37915/health
   ```

### "Los cambios en el JSON no se aplican"

El plugin carga la configuración **al iniciar** el servidor. Cambios requieren reinicio:
```bash
pkill -f "opencode serve"
opencode serve --hostname 127.0.0.1 --port 37915 &
```

### "Zen se conectó solo"

Zen no se conecta solo, pero si ejecutaste `opencode auth login` y seleccionaste Zen, queda guardado. Verificar:
```bash
cat ~/.local/share/opencode/auth.json
```

Para desconectar: quitar la entrada `"opencode"` del JSON.

---

## Evolución futura

### Escenarios posibles

| Escenario | Cambio en arquitectura |
|---|---|
| Añadir más proveedores | Nueva carpeta en repo (`copilot/`, `openai/`) |
| Cambiar de LXC a VPS | Migrar snapshot del contenedor |
| Añadir CI/CD | Nuevo agente en config para pipelines |
| Múltiples desarrolladores | Auth por usuario, no global |
| Cliente desktop en Windows | Usar desktop en lugar de OpenChamber web |

### Métricas a monitorizar

- Requests por modelo al día/semana
- Cuántas veces se activan fallbacks
- Coste real vs. presupuesto ($12/5h)
- Tiempo medio de respuesta por tier
