# Capacidades de los modelos Go

> Evaluación de los modelos configurados en `oh-my-openagent.json`.

## Para qué están optimizados

| Modelo | Fortaleza | Uso asignado en esta config |
|---|---|---|
| **DeepSeek V4 Flash** | Velocidad y coste | Librarian, Explore, Sisyphus-Junior |
| **DeepSeek V4 Pro** | Balance calidad/coste | Hephaestus, Atlas |
| **Kimi K2.6** | Agentic y orquestación | Sisyphus, Code-reviewer |
| **GLM-5.1** | Reasoning y planning | Oracle, Prometheus |
| **MiMo V2.5** | Multimodal (lectura de imágenes) | Multimodal-looker, Visual-engineering |

## Benchmarks relevantes

- **V4 Pro:** LiveCodeBench 93.5% (supera a Claude Opus)
- **Qwen3.6 Plus:** Terminal-Bench 61.6% (supera a Claude 4.5)
- **K2.6:** SWE-Pro 58.6% (a 6 puntos de Claude Opus 4.7)

## Compromisos

En tareas de arquitectura desde cero o bugs de producción muy sutiles, los modelos Go pueden necesitar 1-2 iteraciones extra comparados con frontier (Claude Opus, GPT-5.5). Para el 80% del trabajo diario, la diferencia es mínima.

## Cuándo usar Zen

Conectar Zen manualmente solo cuando:
- Un modelo Go se atasca después de 3 iteraciones
- Arquitectura de sistema desconocido desde cero
- Code review de seguridad crítica
- Incidente de producción bajo presión

Para más detalles sobre la estrategia completa, ver `docs/architecture.md`.
