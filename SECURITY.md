# Seguridad y privacidad

## Alcance

Navegador consulta asociaciones locales y solicita a macOS cambiar únicamente los esquemas HTTP y HTTPS entre dos identificadores permitidos: Safari y Google Chrome. El inicio automático es una acción explícita del usuario mediante ServiceManagement.

La app no contiene llamadas de red, telemetría, actualización automática, lectura del historial, acceso a contraseñas o ejecución de comandos. El dominio `example.invalid` sirve únicamente para consultar asociaciones locales; nunca se abre ni se visita. Los scripts de compilación sí ejecutan las herramientas de desarrollo locales.

No solicita permisos de accesibilidad, grabación de pantalla, disco completo ni privilegios de administrador. No incorpora claves, certificados de distribución ni dependencias externas.

## Controles implementados

- Lista cerrada de navegadores y validación de instalación.
- Cambios secuenciales con bloqueo de solicitudes superpuestas.
- Cancelación y errores detienen la secuencia; no hay reintentos ni rollback silenciosos.
- Estado real de ambos protocolos después del cambio; no se presupone éxito por recibir un callback.
- Inicio automático opcional desde el menú; se eliminó el argumento que podía registrarlo al arrancar.
- Diagnóstico sin rutas personales.
- Binarios, cachés, logs, archivos de entorno y claves excluidos de Git.
- CI con permisos de lectura, sin credenciales persistentes y acción fijada a un commit; Dependabot propone actualizaciones.
- Firma local con hardened runtime, sin excepciones de entitlements.

## Límites

Esto es una revisión de alcance limitado, no una certificación ni garantía de ausencia de vulnerabilidades. La app no usa App Sandbox. La firma ad hoc no acredita identidad, y hardened runtime no reemplaza el sandbox ni la notarización.

Launch Services resuelve las aplicaciones instaladas por identificador; no hacemos una verificación independiente de su firma de proveedor. Se presupone un sistema y navegadores legítimos. Un atacante que ya controle la cuenta o el equipo queda fuera del modelo de amenaza.

HTTP y HTTPS no se cambian de forma atómica: cancelar la segunda confirmación puede dejar una selección parcial, que se muestra expresamente. Las pruebas automatizadas usan un sistema simulado y no ejercitan los diálogos reales de consentimiento.

## Antes de distribuir binarios a terceros

- Validar uso e inicio automático en hardware Intel y Apple Silicon y versiones de macOS soportadas.
- Usar certificado Developer ID, hardened runtime y notarización de Apple; verificar el resultado antes de publicar.
- Gestionar certificados y credenciales únicamente como secretos del entorno de firma, nunca dentro del repositorio.
- Publicar versión, cambios y sumas de comprobación del artefacto.
- No pedir que se desactive Gatekeeper ni eliminar la cuarentena como solución de instalación.

## Reportar un problema

No publiques credenciales, datos personales ni detalles explotables en un issue público. Usa el [reporte privado de vulnerabilidades](https://github.com/hectormonte1/navegador-menu/security/advisories/new), habilitado para este repositorio. Si no está disponible, abre únicamente un issue solicitando un canal privado, sin incluir el hallazgo sensible.

La revisión de esta versión se documenta en [VALIDATION.md](docs/VALIDATION.md).
