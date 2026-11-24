# Asistente K2 — 1.0.0

Aplicación web local para Windows con chat IA, memoria persistente por proyecto, recepción y clasificación de archivos, proveedores configurables y agente OpenCode opcional.

## Estado de esta primera sincronización

Este repositorio ya tiene el punto de entrada, configuración de seguridad, plantilla CI y publicador. La importación del resto del código fuente se completa desde el paquete local de K2 1.0.0.

1. Descarga y extrae el paquete Asistente K2 1.0.0.
2. Ejecuta `SUBIR_A_GITHUB.cmd` desde la raíz de esa carpeta.
3. Autoriza Git Credential Manager cuando abra GitHub.
4. El script sincroniza el código y la documentación, excluyendo memoria local, claves, registros, dependencias instaladas y binarios privados.
5. GitHub Actions resuelve el lockfile y ejecuta las pruebas en Windows con Node 22, 24 y 26.

Hasta completar esa sincronización, el árbol de este repositorio es un bootstrap y no debe usarse todavía para instalar K2.

## Requisitos del proyecto

- Windows 10/11 x64.
- Node.js 22, 24 o 26 y npm.
- Conexión a `https://registry.npmjs.org/` durante la primera instalación.
- Clave de un proveedor IA configurada localmente.

## Control después de importar el código

- `K2.cmd --status`: consulta el estado.
- `K2.cmd --stop`: solicita cierre ordenado.
- `K2.cmd --force-stop`: fuerza el cierre solo del proceso K2 identificado, después de confirmación.
- `K2.cmd --restart`: reinicia K2.
- `K2.cmd --node`: abre el gestor fnm para Node.js.
- `K2.cmd --repair-deps`: repara dependencias.
- `K2.cmd --reset-deps`: reinstala node_modules, sin borrar memoria.
- `K2.cmd --npm-diagnose`: clasifica el último error npm.
- `K2.cmd --verify`: ejecuta sintaxis, pruebas y comprobaciones de release.

## Datos y credenciales

Conversaciones, memoria, proyectos autorizados y credenciales cifradas permanecen fuera del repositorio en `%LOCALAPPDATA%\\AsistenteK2`. No publiques `.env`, `data/`, `node_modules/`, logs, DPAPI ni binarios locales.

## Seguridad

El servidor escucha solo en `127.0.0.1:8787`. El cierre forzado no termina todos los procesos Node; identifica el puerto, PID y ruta de la instalación antes de actuar.
