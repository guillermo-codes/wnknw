[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$Repository = 'https://github.com/guillermo-codes/wnknw.git'
$Branch = 'main'

function Refresh-Path {
  $machine = [Environment]::GetEnvironmentVariable('Path','Machine')
  $user = [Environment]::GetEnvironmentVariable('Path','User')
  $env:Path = @($machine,$user) -join ';'
}

Write-Host ''
Write-Host 'ASISTENTE K2 1.0.0 — PUBLICAR CÓDIGO FUENTE' -ForegroundColor Cyan
Write-Host 'Este proceso copia solo el código y la documentación al repositorio.'
Write-Host 'No publica data, claves, node_modules, registros ni herramientas privadas.'
Write-Host ''

$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) {
  $winget = Get-Command winget -ErrorAction SilentlyContinue
  if (-not $winget) { throw 'Git no está instalado y winget no está disponible. Instala Git for Windows desde https://git-scm.com/download/win y vuelve a ejecutar este archivo.' }
  $answer = Read-Host 'Git no está instalado. ¿Deseas instalar Git for Windows mediante winget? (S/N)'
  if ($answer -notmatch '^(s|si|sí|y|yes)$') { throw 'Publicación cancelada: se necesita Git for Windows.' }
  & $winget.Source install --id Git.Git --exact --accept-package-agreements --accept-source-agreements
  if ($LASTEXITCODE -ne 0) { throw 'winget no pudo instalar Git for Windows.' }
  Refresh-Path
  $git = Get-Command git -ErrorAction SilentlyContinue
  if (-not $git) { throw 'Git se instaló, pero esta terminal no lo detecta. Cierra la ventana, vuelve a abrirla y ejecuta SUBIR_A_GITHUB.cmd.' }
}

$stage = Join-Path $env:TEMP ('K2-github-publish-' + [guid]::NewGuid().ToString('N'))
Write-Host 'Descargando la versión actual del repositorio...' -ForegroundColor Cyan
& $git.Source clone --branch $Branch $Repository $stage
if ($LASTEXITCODE -ne 0) { throw 'No se pudo clonar GitHub. Comprueba internet, acceso al repositorio y autenticación de Git Credential Manager.' }

$excludeDirs = @(
  (Join-Path $ProjectRoot 'node_modules'),
  (Join-Path $ProjectRoot 'data'),
  (Join-Path $ProjectRoot '.git'),
  (Join-Path $ProjectRoot 'secrets'),
  (Join-Path $ProjectRoot 'tools\opencode'),
  (Join-Path $ProjectRoot 'opencode-data'),
  (Join-Path $ProjectRoot 'opencode-state'),
  (Join-Path $ProjectRoot 'opencode-cache')
) | Where-Object { Test-Path -LiteralPath $_ }

$robocopy = Get-Command robocopy.exe -ErrorAction Stop
$copyArgs = @($ProjectRoot,$stage,'/E','/R:1','/W:1','/NFL','/NDL','/NJH','/NJS','/NP')
foreach ($directory in $excludeDirs) { $copyArgs += @('/XD',$directory) }
$copyArgs += @('/XF','.env','.env.*','*.env','*.log','*.dpapi','*.pem','*.key','id_rsa','id_ed25519')
& $robocopy.Source @copyArgs | Out-Null
$copyCode = $LASTEXITCODE
if ($copyCode -ge 8) { throw "Robocopy falló con código $copyCode. No se ha ejecutado git push." }

# Defensa adicional: secretos y memoria nunca deben entrar en el índice Git.
$forbidden = @('.env','data','node_modules','secrets')
$gitStatus = & $git.Source -C $stage status --short --untracked-files=all
foreach ($line in $gitStatus) {
  foreach ($item in $forbidden) {
    if ($line -match [regex]::Escape($item)) { throw "El control detectó una ruta privada en el staging: $line" }
  }
}

& $git.Source -C $stage config user.name 'Guillermo K2 Publisher'
& $git.Source -C $stage config user.email '344693208+guillermo-codes@users.noreply.github.com'
& $git.Source -C $stage add -A
if ($LASTEXITCODE -ne 0) { throw 'git add falló.' }
& $git.Source -C $stage diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
  Write-Host 'GitHub ya contiene los mismos archivos. No hay cambios para publicar.' -ForegroundColor Green
  Write-Host "Carpeta temporal: $stage"
  exit 0
}
if ($LASTEXITCODE -ne 1) { throw 'No se pudo comprobar el staging de Git.' }

Write-Host ''
Write-Host 'Se publicarán los archivos de código y documentación de K2 1.0.0.' -ForegroundColor Yellow
Write-Host 'Git Credential Manager puede abrir el navegador para autorizar tu cuenta.'
& $git.Source -C $stage commit -m 'release: Asistente K2 1.0.0'
if ($LASTEXITCODE -ne 0) { throw 'git commit falló. Comprueba la identidad de Git y vuelve a intentarlo.' }
& $git.Source -C $stage push origin $Branch
if ($LASTEXITCODE -ne 0) { throw 'git push falló. No se borró el staging; revisa autenticación o conflictos y vuelve a ejecutar la publicación.' }

Write-Host ''
Write-Host 'Publicación completada.' -ForegroundColor Green
Write-Host "Repositorio: https://github.com/guillermo-codes/wnknw"
Write-Host "Carpeta de staging: $stage"
Write-Host 'El workflow Windows CI se ejecutará en GitHub Actions.'
