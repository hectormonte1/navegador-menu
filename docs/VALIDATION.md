# Validación — 2026-09-29

## Comprobado localmente

- 12 comprobaciones de lógica pasaron con un sistema simulado.
- Compilación nativa arm64 y compilación cruzada x86_64 completadas con warnings tratados como errores.
- Manifiesto válido, deployment target macOS 13 y firma ad hoc con hardened runtime verificados durante la compilación.
- Revisión de código y búsqueda de patrones de claves privadas, tokens de GitHub, claves AWS, rutas personales y referencias privadas: sin hallazgos en los archivos preparados para publicar.
- Los binarios y cachés están excluidos del historial.
- Sintaxis de scripts comprobada.

## Corrección observada durante la revisión

El directorio sincronizado añadió metadatos FinderInfo al bundle copiado, invalidando su comprobación de firma. El script ahora elimina únicamente ese atributo del bundle generado y verifica también la copia final. No elimina cuarentena ni desactiva Gatekeeper. Si un servicio de sincronización vuelve a añadir metadatos más tarde, compila en una carpeta local no sincronizada.

## No comprobado todavía

- Ejecución del workflow remoto hasta que el repositorio esté publicado.
- Interacción visual y confirmaciones reales de esta revisión completa.
- Ejecución en hardware Intel: se compiló para Intel, no se verificó allí.
- Inicio de sesión real, cierre de sesión y reinicio con esta revisión.
- Firma Developer ID, notarización y distribución de binarios.

La revisión no reemplaza una auditoría de seguridad independiente. No se modificaron asociaciones del usuario para ejecutar las pruebas.
