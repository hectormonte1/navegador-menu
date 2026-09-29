# Registro de cambios

## 1.1.0 — 2026-09-29

Primera versión preparada para historial público.

- Separación entre menú, lógica de cambio y APIs del sistema.
- Pruebas de cancelación, fallos parciales y concurrencia sin alterar preferencias.
- Empaquetado ZIP por arquitectura para evitar alteraciones de firma por metadatos de sincronización.
- Compilación para Intel o Apple Silicon con macOS 13 como mínimo explícito.
- Restricción de identificadores, comprobación del resultado y eliminación del argumento de alta automática al iniciar sesión.
- Menú estable mientras está abierto y bloqueo de acciones durante un cambio.
- Diagnóstico sin rutas personales; identificador público propio del proyecto.
- Adaptador compatible con las anotaciones de concurrencia de SDKs anteriores.
- Documentación, política de seguridad, CI y exclusión de artefactos generados.

## Prototipos — 2026-09-29

Primer selector local de Safari/Chrome y posterior incorporación de inicio automático. Estas etapas preceden al historial Git público; no constituyen releases publicadas.
