# Navegador 🌐

[![Build and test](https://github.com/hectormonte1/navegador-menu/actions/workflows/ci.yml/badge.svg)](https://github.com/hectormonte1/navegador-menu/actions/workflows/ci.yml)

Cambia entre Safari y Google Chrome desde la barra de menús de macOS.

Un pequeño proyecto de portafolio: parte de una necesidad cotidiana, usa APIs nativas y documenta cómo pasó de prototipo a una aplicación mantenible.

```text
🌐 Safari
┌──────────────────────────────────┐
│ ✓ Safari                         │
│   Google Chrome                  │
│ ──────────────────────────────── │
│   Abrir al iniciar sesión        │
│ ──────────────────────────────── │
│   Salir                          │
└──────────────────────────────────┘
```

*Esquema ilustrativo del menú, no una captura de pantalla.*

## Qué hace

- Muestra el navegador predeterminado y permite elegir Safari o Chrome.
- Comprueba HTTP y HTTPS por separado; una marca parcial indica que difieren.
- Respeta las confirmaciones y cancelaciones de macOS.
- Ofrece inicio automático opcional, desactivado por defecto para una instalación nueva.
- Se actualiza al abrir el menú y cada cinco segundos cuando el menú está cerrado.
- Funciona sin servidores, cuentas, analítica ni dependencias de terceros.

## Requisitos y compilación

macOS 13 o posterior. Para compilar: Xcode Command Line Tools con Swift 5.9 o posterior (Xcode 15+). Safari viene con macOS; Chrome debe estar instalado para seleccionarlo.

```bash
bash scripts/test.sh
bash build.sh
```

El resultado es `build/Navegador-arm64.zip` o `build/Navegador-x86_64.zip`, según la arquitectura. La arquitectura se detecta automáticamente; también puede elegirse explícitamente:

```bash
ARCH=arm64 bash build.sh    # Apple Silicon
ARCH=x86_64 bash build.sh   # Intel
```

Cada ejecución genera una sola arquitectura. La compilación no instala ni abre la app y no cambia preferencias. La versión mínima de macOS se fija tanto en el ejecutable como en el manifiesto para evitar incompatibilidades accidentales.

## Instalación y uso

1. Compila en el Mac donde vas a usarla.
2. Descomprime el ZIP de tu arquitectura, copia `Navegador.app` a Aplicaciones con Finder y ábrela.
3. Pulsa el globo, selecciona un navegador y acepta la confirmación de macOS si aparece.
4. Si quieres, activa «Abrir al iniciar sesión». macOS puede pedir autorización en Ajustes del Sistema.

La compilación local lleva firma **ad hoc** y hardened runtime. No tiene firma Developer ID ni notarización: no se ofrece todavía como descarga certificada para terceros. No desactives Gatekeeper para instalarla; consulta [SEGURIDAD](SECURITY.md).

Al actualizar desde el prototipo, desactiva su inicio automático y ciérralo antes de abrir esta versión. El identificador de la app cambió a uno del proyecto; mantener ambos puede mostrar dos menús.

«Salir» cierra la app pero no desactiva el inicio automático. Para desinstalar: desmarca esa opción, sal y mueve la app a la Papelera. El navegador predeterminado queda como lo elegiste.

## Desarrollo y pruebas

| Archivo | Responsabilidad |
| --- | --- |
| `Sources/main.swift` | Menú, mensajes e inicio de sesión |
| `Sources/BrowserService.swift` | Estado y secuencia de cambio verificable |
| `Sources/WorkspaceBrowserSystem.swift` | Integración con APIs de macOS |
| `Resources/Info.plist` | Identidad y versión mínima |
| `Tests/BrowserServiceTests.swift` | Pruebas con sistema simulado |

Las pruebas no cambian preferencias reales. Cubren estado desconocido, selección parcial/completa, ausencia del navegador, identificadores no admitidos, cambios innecesarios, cancelación, fallos parciales, confirmaciones sin efecto y concurrencia. GitHub Actions ejecuta las pruebas y compila las dos arquitecturas; eso no sustituye una prueba visual en hardware Intel y Apple Silicon.

Diagnóstico local opcional (solo consulta; no cambia preferencias):

```bash
/Applications/Navegador.app/Contents/MacOS/Navegador --diagnose
```

Prueba manual antes de distribuir: cambia Safari → Chrome → Safari, comprueba ambos protocolos, cancela una confirmación y verifica que el menú muestre el estado real. Prueba también el inicio automático después de guardar tu trabajo. Las páginas ya abiertas y las aplicaciones que fuerzan su propio navegador no cambian.

## Historia del proyecto

Lee [el caso de estudio](docs/CASE_STUDY.md), [las decisiones técnicas](docs/ARCHITECTURE.md) y [el registro de cambios](CHANGELOG.md). El historial Git empieza con esta versión saneada: los prototipos anteriores se documentan, pero no se inventan commits retroactivos.

Creado por [hectormonte1](https://github.com/hectormonte1), con asistencia de Codex. Para contribuir, consulta [CONTRIBUTING](CONTRIBUTING.md).

## Permisos de reutilización

Este repositorio se publica como portafolio. Todavía no se ha elegido una licencia de código abierto; su visibilidad pública no concede automáticamente permisos generales de reutilización.
