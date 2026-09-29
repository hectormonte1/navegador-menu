# Del problema cotidiano al proyecto de portafolio

## Necesidad

Cambiar entre Safari y Chrome sin entrar cada vez a Ajustes del Sistema. El resultado es una utilidad discreta en la barra superior, con el estado actual visible.

## Evolución

1. **Prototipo:** globo, nombre y selección de dos navegadores.
2. **Compatibilidad:** una compilación inicial heredó un requisito de macOS superior al equipo. La solución fue fijar el deployment target; el proceso actual también selecciona la arquitectura.
3. **Uso diario:** inicio automático opcional y representación de HTTP/HTTPS cuando difieren.
4. **Preparación pública:** separación de responsabilidades, pruebas, limpieza de referencias privadas y automatización de compilación.

## Qué demuestra

- Convertir una necesidad concreta en una utilidad nativa pequeña.
- Integrar APIs del sistema respetando la decisión del usuario.
- Modelar operaciones parciales y fallos, sin presentar falsos éxitos.
- Mantener código comprobable, documentación y un historial honesto.

La implementación se desarrolló con asistencia de Codex. El alcance no incluye un navegador, un proxy, una extensión ni un servicio remoto.

## Pendientes reales

Prueba manual completa de esta revisión, firma Developer ID y notarización para distribución, decisión de licencia y capturas públicas sin información personal. No se atribuyen métricas de rendimiento ni seguridad que no se hayan medido.
