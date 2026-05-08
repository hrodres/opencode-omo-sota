# Capacidades y Limitaciones

> Qué puedes construir con OpenCode Go + Oh My OpenAgent, y qué NO.

## Honestidad primero

Este stack es una herramienta de **ingeniería de software de primer nivel**, no una varita mágica. Es excelente para ciertas cosas y mediocre para otras. Esta página te dice la verdad para que no pierdas tiempo intentando lo imposible.

---

## ✅ Proyectos ideales (donde brilla)

### Backend, APIs y lógica de negocio

**Tu stack está en su elemento.** Los modelos Go son programadores excepcionales:

| Tipo de proyecto | Modelos involucrados | ¿Qué tan bien? |
|---|---|---|
| APIs REST/GraphQL | V4 Pro, K2.6 | ⭐⭐⭐⭐⭐ Excelente. LiveCodeBench 93.5% supera a Claude |
| Microservicios | V4 Pro | ⭐⭐⭐⭐⭐ Sólido para arquitectura estándar |
| Bases de datos (SQL/NoSQL) | V4 Pro, Qwen3.6 | ⭐⭐⭐⭐⭐ Muy bueno, Qwen tiene 1M de contexto |
| Scripts de automatización | V4 Flash | ⭐⭐⭐⭐⭐ Prácticamente ilimitado en requests |
| Autenticación / Autorización | V4 Pro, K2.6 | ⭐⭐⭐⭐⭐ Bien documentado en training data |
| Refactorización de código legacy | K2.6 | ⭐⭐⭐⭐⭐ SWE-Pro 58.6%, detecta bugs reales |
| Tests unitarios/integración | V4 Pro, K2.6 | ⭐⭐⭐⭐⭐ Muy sólido |
| Docker / CI/CD básico | V4 Pro | ⭐⭐⭐⭐ Bueno para Dockerfiles, docker-compose |

**Ejemplo real:**
> "Construye una API de e-commerce con Node.js, Express, PostgreSQL y autenticación JWT. Incluye tests."

Esto lo hará **muy bien**. El código será funcional, testeado, con buena estructura.

### Webs funcionales y SaaS

| Tipo de proyecto | Modelos involucrados | ¿Qué tan bien? |
|---|---|---|
| Dashboards y admin panels | V4 Pro, K2.6 | ⭐⭐⭐⭐⭐ Perfecto. Interfaces utilitarias funcionan genial |
| SaaS con CRUD | V4 Pro, K2.6 | ⭐⭐⭐⭐⭐ Excelente |
| Landing pages simples | K2.6 | ⭐⭐⭐⭐ Funcional, pero diseño básico |
| Internal tools | V4 Flash, V4 Pro | ⭐⭐⭐⭐⭐ Ideal |
| Documentación técnica | Qwen3.6 | ⭐⭐⭐⭐⭐ Bueno para writing |

**Ejemplo real:**
> "Crea un dashboard de analytics con React y una API en Python."

El backend será excelente. El frontend será **funcional** (tablas, gráficos, formularios), pero no ganará premios de diseño.

### Apps móviles (código)

| Aspecto | Capacidad | Nota |
|---|---|---|
| Lógica de app | ⭐⭐⭐⭐⭐ Excelente | React Native, Flutter |
| Integración con APIs | ⭐⭐⭐⭐⭐ Perfecto | 
| UI nativa | ⭐⭐⭐ Medio | Funcional pero no pixel-perfect |
| Publicación App Store | ❌ No puede | Es un agente de código, no DevOps |

**Ejemplo real:**
> "Crea una app de lista de tareas en React Native con Expo."

El código funcionará. La UI será usable pero básica. La publicación la tendrás que hacer tú.

---

## ⚠️ Posible pero con limitaciones

### Frontend moderno con diseño exigente

**La verdad incómoda:** Los modelos Go son **programadores excelentes pero diseñadores mediocres**.

| Aspecto frontend | Capacidad | Modelo | Nota |
|---|---|---|---|
| Componentes React/Vue | ✅ Bueno | K2.6, V4 Pro | Generan código limpio |
| Lógica de estado (Redux/Zustand) | ✅ Muy bueno | K2.6 | 
| CSS moderno (Tailwind, Grid, Flex) | ⚠️ Medio | K2.6 | Funciona pero no es creativo |
| Animaciones complejas (GSAP, Framer) | ❌ Débil | — | No es su fuerte |
| Microinteracciones | ❌ Débil | — | 
| Diseño responsive avanzado | ⚠️ Medio | K2.6 | Funciona pero necesita iteración |
| Screenshot-to-code | ⚠️ Parcial | MiMo V2.5 | Ve imágenes pero no está especializado |

**Ejemplo real:**
> "Crea una web tipo Stripe con animaciones de scroll y gradientes complejos."

Esto **no lo hará bien**. Generará una web funcional pero sin el "feeling" premium de Stripe.

### Análisis de imágenes (multimodal)

**MiMo V2.5 puede hacerlo, pero con límites:**

| Tarea | ¿Puede? | ¿Qué tan bien? |
|---|---|---|
| Describir una imagen | ✅ Sí | Bien, comparable a Gemini |
| Extraer texto de imagen (OCR) | ✅ Sí | Bueno |
| Analizar gráficos y charts | ✅ Sí | Competitivo |
| Screenshot-to-code | ⚠️ Sí, pero... | Funciona porque "ve" la imagen, pero **no está entrenado específicamente** para esto |
| **Editar imágenes** | ❌ No | Ningún LLM edita imágenes |
| **Generar imágenes** | ❌ No | No es DALL-E, Midjourney ni Stable Diffusion |

**Ejemplo real:**
> "Analiza este screenshot de un dashboard y dime qué mejorar en la UX."

✅ Lo hará bien. Te dará feedback útil.

> "Recrea este diseño exacto a partir de esta imagen."

⚠️ Lo intentará, pero no será pixel-perfect. Necesitarás iterar.

---

## ❌ Lo que NO puedes hacer (no intentarlo)

### Diseño gráfico y branding

Ningún modelo de tu stack **genera** imágenes. No harás:
- Logos
- Ilustraciones
- Assets visuales para apps
- Branding completo

**Herramientas alternativas:** DALL-E 3, Midjourney, Stable Diffusion, Figma con plugins de IA, o un diseñador humano.

### Generación de contenido multimedia

| Tipo | ¿Puede? | Razón |
|---|---|---|
| **Video** | ❌ No | MiMo analiza video (lo ve), pero no lo edita ni genera |
| **Audio/Música** | ❌ No | Puede transcribir, pero no componer ni producir |
| **Imágenes** | ❌ No | Ningún modelo es de difusión |
| **3D/Modelado** | ❌ No | Fuera de alcance |

### Data Science avanzado y ML

| Tarea | ¿Puede? | Nota |
|---|---|---|
| Escribir código de ML (PyTorch, TensorFlow) | ✅ Sí | Genera código funcional |
| **Entrenar modelos** | ❌ No | Necesita GPU y horas. El LLM solo escribe el código |
| Fine-tuning | ⚠️ Parcial | Puede escribir scripts, pero no ejecutar el entrenamiento |
| Análisis de datos (pandas, numpy) | ✅ Sí | Bien para ETL y análisis estándar |

### DevOps end-to-end

| Tarea | ¿Puede? | Nota |
|---|---|---|
| Escribir Dockerfiles | ✅ Sí | Muy bueno |
| Escribir Terraform/CloudFormation | ✅ Sí | Sólido |
| **Desplegar a AWS/GCP/Azure** | ❌ No | No tiene credenciales ni acceso a tu cloud |
| Configurar CI/CD pipelines | ✅ Sí | Escribe YAML, pero no configura los runners |

---

## 🎯 Cuándo necesitarás Zen (frontier)

Conectar Zen manualmente solo para:

| Escenario | ¿Por qué Zen? | Modelo frontier recomendado |
|---|---|---|
| **Frontend premium** (pixel-perfect, animaciones complejas) | Claude/GPT tienen mejor "gusto" visual | Claude Opus 4.7 |
| **Arquitectura desde cero** (sistema desconocido) | Razonan mejor con requisitos ambiguos | GPT-5.5, Claude Opus |
| **Code review de seguridad** | Detectan vulnerabilidades sutiles | Claude Opus 4.7 |
| **Incidentes de producción** | Razonan mejor bajo presión | Claude Opus 4.7 |
| **Cuando un modelo Go "se atasca"** | Si después de 3 iteraciones no resuelve | GPT-5.5, Claude Opus |
| **Tecnologías muy nuevas** | Más contexto en training data | GPT-5.5 |

**Procedimiento:**
1. Conecta Zen: `opencode auth login`
2. Usa modelo frontier explícitamente (ej: `opencode-zen/claude-opus-4-7`)
3. Desconecta Zen al terminar: editar `~/.local/share/opencode/auth.json`

---

## 📊 Comparativa rápida

| Tipo de proyecto | Con tu stack Go | Con Zen (frontier) |
|---|---|---|
| API REST completa | ✅ Perfecto | ✅ Perfecto (overkill) |
| Dashboard funcional | ✅ Perfecto | ⚠️ Costoso innecesariamente |
| Web tipo Apple/Stripe | ⚠️ Medio (funcional, no premium) | ✅ Bueno |
| App móvil básica | ✅ Funcional | ✅ Mejor UI |
| Logo e ilustraciones | ❌ No puede | ❌ No puede (ningún LLM genera imágenes) |
| Análisis de imágenes | ⚠️ Parcial | ✅ Mejor (GPT-4V, Claude vision) |
| Refactorización legacy | ✅ Excelente | ✅ Excelente (coste innecesario) |

---

## 💡 Regla de oro

> **Usa Go para el 95% del trabajo técnico. Reserva Zen para el 5% donde la diferencia entre "funciona" y "excelente" vale el coste.**

Para la mayoría de proyectos de software (APIs, SaaS, automatizaciones, internal tools), tu stack actual es más que suficiente. Solo considera frontier cuando:
1. El diseño visual es crítico para el negocio
2. La arquitectura es completamente nueva y ambigua
3. Estás en una situación de alta presión (producción caída)
4. Un modelo Go ha fallado 3 veces seguidas con el mismo problema
