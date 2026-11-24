# Asistente K2 — 1.0.0

Aplicación web local para Windows con chat de IA, memoria persistente por proyecto, carga y clasificación de archivos, proveedores configurables y agente de código OpenCode opcional.

## Requisitos

- Windows 10/11 x64.
- Node.js 22, 24 o 26 y npm.
- Conexión a `https://registry.npmjs.org/` durante la primera instalación.

## Inicio rápido

1. Extrae el paquete en una carpeta nueva.
2. Ejecuta `K2.cmd`.
3. Pega la clave del proveedor en el cuadro seguro de Windows si se solicita.
4. El lanzador comprueba las dependencias, inicia el servidor y abre `http://127.0.0.1:8787`.

## Control

- `K2.cmd --status`: estado de K2.
- `K2.cmd --stop`: cierre ordenado.
- `K2.cmd --force-stop`: cierre forzado del proceso K2 identificado, con confirmación.
- `K2.cmd --restart`: reinicio.
- `K2.cmd --node`: gestor de versiones Node mediante fnm.
- `K2.cmd --repair-deps`: reparación de dependencias.
- `K2.cmd --reset-deps`: reinstalar `node_modules` sin borrar memoria.
- `K2.cmd --npm-diagnose`: clasificar errores npm.
- `K2.cmd --verify`: pruebas y diagnósticos.

## Datos privados

Conversaciones, notas, memoria, claves DPAPI y proyectos autorizados se guardan fuera del repositorio en `%LOCALAPPDATA%\\AsistenteK2`. No publiques `.env`, `data/`, `node_modules/`, credenciales ni registros.

## Verificación

Ejecuta `npm run verify`. GitHub Actions comprueba Node 22/24/26 en Windows, instala usando el lockfile y analiza la sintaxis PowerShell. El proyecto no garantiza que tu proveedor IFM o red local estén disponibles; esas conexiones deben probarse en el equipo donde se ejecuta K2.

Consulta `docs/OPERACION-Y-RECUPERACION.md` y `docs/SELF-CHECKS.md` para operación y diagnóstico.
