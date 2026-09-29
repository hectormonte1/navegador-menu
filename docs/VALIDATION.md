# Validación — 2026-09-29

## Comprobado localmente

- 12 comprobaciones de lógica pasaron con un sistema simulado.
- Compilación nativa arm64 y compilación cruzada x86_64 completadas con warnings tratados como errores.
- Manifiesto válido, deployment target macOS 13 y firma ad hoc con hardened runtime verificados durante la compilación.
- Revisión de código y búsqueda de patrones de claves privadas, tokens de GitHub, claves AWS, rutas personales y referencias privadas: sin hallazgos en los archivos preparados para publicar.
- Los binarios y cachés están excluidos del historial.
- Sintaxis de scripts comprobada.

## Corrección observada durante la revisión

El directorio sincronizado añadió metadatos FinderInfo al bundle copiado, invalidando su comprobación de firma. Eliminar el atributo no fue suficiente: el servicio de sincronización lo volvía a crear. El script ahora verifica la app en una carpeta temporal local y la empaqueta en un ZIP por arquitectura, sin copiar el bundle abierto a la carpeta sincronizada. No elimina cuarentena ni desactiva Gatekeeper.

La primera ejecución de CI pasó las pruebas de lógica y detectó una advertencia de aislamiento de `NSWorkspace` en el SDK del runner. Se cambió el adaptador a la API con callback envuelta en una continuación, manteniendo la llamada en el actor principal sin relajar `warnings-as-errors`.

## Comprobado en GitHub

- [Build and test: ejecución correcta](https://github.com/hectormonte1/navegador-menu/actions/runs/36622368028) para el commit `215da8a`: pruebas de lógica y compilaciones arm64/x86_64 completadas.
- Detección de secretos y protección de subida habilitadas.
- Reportes privados de vulnerabilidades habilitados.
- Archivos publicados como código fuente; no se publicaron credenciales ni binarios de distribución.
- Verificación local adicional: ambos ZIP se extrajeron y sus firmas ad hoc pasaron la comprobación estricta.

## No comprobado todavía
- Interacción visual y confirmaciones reales de esta revisión completa.
- Ejecución en hardware Intel: se compiló para Intel, no se verificó allí.
- Inicio de sesión real, cierre de sesión y reinicio con esta revisión.
- Firma Developer ID, notarización y distribución de binarios.

La revisión no reemplaza una auditoría de seguridad independiente. No se modificaron asociaciones del usuario para ejecutar las pruebas.
