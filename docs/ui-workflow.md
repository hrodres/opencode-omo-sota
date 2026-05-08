# Flujo de trabajo para UI de calidad

> Cómo combinar Oh My OpenAgent con herramientas especializadas para crear webs con buen diseño.

## La verdad sobre OMO y la UI

**OMO es un ingeniero excepcional pero un diseñador mediocre.** Genera código funcional, bien estructurado y testeado, pero no tiene "gusto" visual ni creatividad para diseño.

Por eso, para webs donde la UI importa, necesitas un **flujo híbrido**:
- **Herramientas especializadas** → para generar el diseño inicial y componentes visuales
- **OMO** → para la arquitectura, backend, lógica y mantenimiento a largo plazo

---

## Herramientas especializadas para UI (mejores que OMO para diseño)

Existen herramientas diseñadas específicamente para generar interfaces de usuario. Son superiores a OMO en este ámbito porque tienen:
- Preview visual en tiempo real
- Iteración visual (ajustar colores, spacing, layout sin escribir código)
- Mejores capacidades de diseño integradas

### Opciones recomendadas

| Herramienta | Qué hace | Ideal para | Precio |
|---|---|---|---|
| **[v0.dev](https://v0.dev)** (Vercel) | Genera componentes React + Tailwind a partir de descripciones o imágenes | Landing pages, dashboards, componentes UI | Gratis (con límites) |
| **[Bolt.new](https://bolt.new)** (StackBlitz) | Entorno completo de desarrollo con IA. Genera apps full-stack. | Prototipos rápidos, MVP, apps completas | Gratis (con límites) |
| **[Lovable.dev](https://lovable.dev)** | Genera apps completas con buena UI. Integración con Supabase. | Apps full-stack con backend incluido | Freemium |
| **Claude Artifacts / Canvas** | Genera y edita componentes React/HTML con preview | Componentes individuales, iteración rápida | Requiere suscripción Claude |
| **GPT-4o / ChatGPT Canvas** | Similar a Claude Artifacts, genera código con preview | Componentes, landing pages simples | Requiere ChatGPT Plus |

### ¿Por qué son mejores que OMO para UI?

- **v0.dev:** Fue entrenado específicamente con componentes de alta calidad. Entiende spacing, color theory, y patrones de diseño modernos.
- **Bolt.new:** Tiene preview en tiempo real. Ves el resultado visual mientras escribes prompts.
- **Claude Artifacts:** Permite iteración visual directa ("más espaciado", "cambiar a azul oscuro", "añadir sombra").

**OMO no tiene ninguna de estas capacidades.** Es un orquestador de código, no un generador de diseño.

---

## Flujo de trabajo recomendado (híbrido)

### Paso 1: Generar UI inicial con herramienta especializada (30% del trabajo)

**Opción A: v0.dev (recomendado para componentes)**

1. Describe lo que quieres:
   > "A modern SaaS landing page with hero section, features grid, pricing cards, and CTA. Dark mode. Blue accent color."

2. v0.dev genera:
   - Componentes React funcionales
   - Tailwind CSS con buen spacing y colores
   - Código limpio y estructurado

3. Exportas el código (Next.js, React, etc.)

**Opción B: Bolt.new (recomendado para apps completas)**

1. Describe tu app:
   > "A task management app with auth, projects, tasks, and team collaboration. Use React, Tailwind, and Supabase."

2. Bolt.new genera:
   - App completa con routing
   - Backend básico (Supabase integration)
   - UI funcional con buen diseño

3. Descargas el proyecto

**Opción C: Figma + AI (recomendado para control total)**

1. Diseñas la UI en Figma usando:
   - Figma AI para layouts iniciales
   - Bibliotecas de componentes (shadcn/ui kit, Tailwind UI kit)
   - Iconos de Heroicons o Lucide

2. Exportas especificaciones:
   - Tokens de diseño (colores, fonts, spacing)
   - Medidas exactas de componentes
   - Estados de hover, focus, disabled

### Paso 2: Pasar a OMO para backend y arquitectura (50% del trabajo)

Una vez tienes la UI inicial, usas OMO para:

| Tarea | Agente | Modelo |
|---|---|---|
| **Arquitectura de datos** | Prometheus | GLM-5.1 |
| **APIs y backend** | Hephaestus | V4 Pro |
| **Autenticación** | Hephaestus | V4 Pro |
| **Base de datos** | Hephaestus | V4 Pro |
| **Lógica de negocio** | Hephaestus | V4 Pro |
| **Integración frontend-backend** | Hephaestus | V4 Pro |
| **Tests** | Code-reviewer | K2.6 |

**Input para OMO:**
```markdown
Tengo una landing page generada con v0.dev (adjunto código).
Necesito:
1. API REST para newsletter signup (/api/newsletter)
2. Base de datos PostgreSQL con Prisma
3. Auth con NextAuth.js (Google OAuth)
4. Dashboard protegido donde los usuarios vean sus suscripciones
5. Tests para todo

El diseño ya está hecho. NO cambies colores, tipografía, ni layout.
Solo implementa la funcionalidad backend y conecta con el frontend existente.
```

### Paso 3: Refinar y mantener con OMO (20% del trabajo)

Una vez la app está funcionando:

| Tarea | Herramienta | Nota |
|---|---|---|
| **Bugfix** | OMO (K2.6/V4 Pro) | Depuración, logs, fixes |
| **Nuevas features** | OMO (Sisyphus → Hephaestus) | Plan + implement |
| **Refactor** | OMO (K2.6) | Mejorar código legacy |
| **Cambios de diseño menores** | v0.dev / Figma | Ajustes visuales puntuales |
| **Nueva página completa** | v0.dev + OMO | v0 genera UI, OMO conecta backend |

---

## Comparativa: Herramienta especializada vs. OMO

| Aspecto | v0.dev / Bolt | OMO + Go | ¿Cuál usar? |
|---|---|---|---|
| **Generar UI inicial** | ⭐⭐⭐⭐⭐ | ⭐⭐ | Herramienta especializada |
| **Arquitectura backend** | ⭐⭐ | ⭐⭐⭐⭐⭐ | OMO |
| **Lógica de negocio** | ⭐⭐ | ⭐⭐⭐⭐⭐ | OMO |
| **Mantenimiento a largo plazo** | ⭐⭐ | ⭐⭐⭐⭐⭐ | OMO |
| **Debugging** | ⭐⭐ | ⭐⭐⭐⭐⭐ | OMO |
| **Tests** | ⭐⭐ | ⭐⭐⭐⭐⭐ | OMO |
| **Iteración visual** | ⭐⭐⭐⭐⭐ | ⭐⭐ | Herramienta especializada |
| **Coste mensual** | Gratis-$20 | $10 (Go) | Depende del proyecto |

---

## Anti-patrones (qué NO hacer)

### ❌ Pedirle a OMO "diseña una web bonita"

OMO generará código funcional pero con diseño genérico (probablemente azul y blanco, bootstrap-style). No será memorable ni diferenciada.

### ❌ Usar v0.dev para todo el proyecto

v0.dev genera UI pero no arquitectura backend robusta. Si tu app crece, necesitarás refactorizar. OMO es mejor para mantener código a largo plazo.

### ❌ Ignorar el diseño y "arreglarlo después"

Es mucho más difícil refactorizar una UI fea que empezar con una buena base. Inviete tiempo en el paso 1.

---

## Ejemplo concreto: SaaS de analytics

### Día 1-2: Diseño con herramienta especializada
- **v0.dev:** Generas landing page, dashboard UI, componentes de charts
- Exportas a Next.js + Tailwind

### Día 3-5: Backend con OMO
- **Sisyphus** planifica arquitectura
- **Hephaestus** implementa:
  - API REST para datos de analytics
  - PostgreSQL con Prisma
  - Auth con NextAuth
  - Integración con Stripe para pagos
- **Code-reviewer** revisa calidad

### Día 6-7: Integración y pulido
- Conectas frontend (de v0.dev) con backend (de OMO)
- Tests end-to-end
- Deploy

**Resultado:** Web con buen diseño (de v0.dev) + backend sólido (de OMO) + mantenible a largo plazo (OMO).

---

## Mi recomendación según el proyecto

| Tipo de proyecto | Herramienta UI | OMO para | Coste total estimado |
|---|---|---|---|
| **Landing page simple** | v0.dev | Nada (solo frontend) | Gratis-$10 |
| **SaaS / App completa** | v0.dev + OMO | Backend, APIs, tests | $10-20/mes |
| **App con backend complejo** | Bolt.new | Refactor, arquitectura, tests | $10-20/mes |
| **Producto con diseño único** | Figma + diseñador | Todo el código | $10/mes + diseñador |
| **MVP rápido** | Lovable.dev | Mantenimiento post-MVP | $10-30/mes |

---

## Recursos recomendados

### Diseño
- [shadcn/ui](https://ui.shadcn.com/) — Componentes accesibles y customizables
- [Tailwind UI](https://tailwindui.com/) — Componentes profesionales (pago)
- [Heroicons](https://heroicons.com/) / [Lucide](https://lucide.dev/) — Iconos consistentes
- [Figma Community](https://www.figma.com/community) — Kits de diseño gratuitos

### Generación UI con IA
- [v0.dev](https://v0.dev)
- [Bolt.new](https://bolt.new)
- [Lovable.dev](https://lovable.dev)

### Animaciones
- [Framer Motion](https://www.framer.com/motion/) — Animaciones React
- [GSAP](https://greensock.com/gsap/) — Animaciones complejas
- [Lottie](https://lottiefiles.com/) — Animaciones vectoriales

---

## Regla de oro

> **No esperes que una sola herramienta lo haga todo.** Usa la herramienta correcta para cada parte del problema. v0.dev para UI, OMO para backend y mantenimiento.
