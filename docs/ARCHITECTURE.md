# Decisiones técnicas

## Swift y AppKit

`NSStatusItem` permite un menú nativo sin ventana principal. `LSUIElement` evita un icono permanente en el Dock. Se requiere macOS 13 por `SMAppService`.

## Fuente de verdad

Launch Services mantiene las asociaciones. No hay copia persistida en preferencias de la app: cada refresco vuelve a consultar HTTP y HTTPS. El timer deja de reconstruir el menú mientras está abierto para no mover opciones bajo el cursor.

## Frontera de pruebas

`BrowserSystem` abstrae lectura y escritura. `WorkspaceBrowserSystem` adapta `NSWorkspace`; `BrowserService` implementa la secuencia, la lista permitida y el bloqueo de concurrencia. Las pruebas inyectan un sistema simulado, por lo que no abren confirmaciones ni modifican preferencias.

## Cambios parciales

El sistema ofrece dos operaciones independientes. La secuencia se detiene ante error/cancelación y consulta el resultado real. No revierte automáticamente el primer cambio: hacerlo podría contradecir el consentimiento que el usuario acaba de dar.

## Inicio automático

Se registra únicamente desde una acción del menú, usando `SMAppService.mainApp`. Se deja al sistema solicitar autorización. No hay LaunchAgent artesanal ni escritura en preferencias privadas.

## Construcción y distribución

El script usa una carpeta temporal, limpia solo ese espacio al terminar y copia el artefacto a `build/`. No instala, no lanza y no descarga dependencias. La firma local es ad hoc, con hardened runtime; una release distribuible necesita firma de identidad y notarización separadas.

## Referencias

- [NSWorkspace: cambiar asociaciones](https://developer.apple.com/documentation/appkit/nsworkspace/setdefaultapplication(at:toopenurlswithscheme:completion:))
- [SMAppService](https://developer.apple.com/documentation/servicemanagement/smappservice)
