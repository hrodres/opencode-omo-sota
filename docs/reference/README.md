# Referencia: JSON Original del Artículo

> Este directorio contiene materiales de referencia. Ninguno de estos archivos es funcional tal cual.

## ¿Qué es esto?

El archivo `article-original.json` es la configuración **exacta** que aparece en el artículo de Jatin K Malik:

[OpenCode Go + Oh My OpenAgent: The Complete Guide to SOTA Model Routing Without Hitting Limits](https://medium.com/@jatinkrmalik/opencode-go-oh-my-openagent-the-complete-guide-to-sota-model-routing-without-hitting-limits-49fdc8cb3417)

## ¿Por qué NO es funcional tal cual?

Aunque el artículo se titula "OpenCode Go", su JSON es una **plantilla híbrida** que mezcla:

- Modelos de OpenCode Go (`opencode-go/*`)
- Modelos que requerirían otros proveedores (Anthropic, OpenAI, Google)
- El artículo asume que el lector puede tener múltiples suscripciones activas

En la práctica, las cadenas de fallback internas de Oh My OpenAgent (las `fallbackChain` hardcodeadas) priorizan proveedores como Anthropic y OpenAI. Si solo tienes OpenCode Go, esas cadenas fallarían o usarían modelos gratuitos de baja calidad.

## Diferencias clave con la versión operativa

| Aspecto | `article-original.json` | `opencode-go/oh-my-openagent.json` |
|---|---|---|
| **Proveedores** | Go + implícitos otros | Solo Go |
| **Zen** | No mencionado explícitamente | Desconectado por defecto |
| **big-pickle** | Presente en cadenas internas del plugin | Excluido de fallbacks explícitos |
| **mimo-v2-omni** | Usado en el artículo | Adaptado a `mimo-v2.5` (modelo disponible) |
| **Funcionalidad** | Requiere múltiples auth | Funciona con solo Go autenticado |

## Para qué sirve este archivo

1. **Referencia histórica:** Ver qué decía el artículo original
2. **Comparación:** Hacer diff contra tu config adaptada para entender los cambios
3. **Aprendizaje:** Entender la filosofía de tiered routing antes de adaptarla

## Cómo usarlo

```bash
# Comparar versión original vs. adaptada
diff docs/reference/article-original.json opencode-go/oh-my-openagent.json
```

## Nota sobre el artículo

El artículo es **genial** explicando la filosofía de routing por tiers, los límites de rate, y la arquitectura general. Pero su JSON es un punto de partida, no una configuración lista para producción con un solo proveedor.

La versión operativa en `opencode-go/oh-my-openagent.json` es la adaptación deliberada de esa filosofía al ecosistema **exclusivo** de OpenCode Go.
