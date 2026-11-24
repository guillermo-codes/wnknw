@echo off
setlocal
cd /d "%~dp0"
if /i "%~1"=="--npm-diagnose" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -NpmDiagnose
) else if /i "%~1"=="--help" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -Help
) else if /i "%~1"=="--status" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -Status
) else if /i "%~1"=="--force-stop" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -ForceStop
) else if /i "%~1"=="--restart" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -Restart
) else if /i "%~1"=="--node" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -NodeManager
) else if /i "%~1"=="--repair-deps" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -RepairDependencies
) else if /i "%~1"=="--reset-deps" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -ResetDependencies
) else if /i "%~1"=="--verify" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -Verify
) else if /i "%~1"=="--change-key" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -ChangeKey
) else if /i "%~1"=="--install-opencode" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -InstallOpenCode
) else if /i "%~1"=="--stop" (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1" -Stop
) else (
  powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0launcher\Start-K2.ps1"
)
set "EXIT_CODE=%ERRORLEVEL%"
if not "%EXIT_CODE%"=="0" (
  echo.
  echo K2 no pudo iniciarse. Revisa el mensaje anterior y %LOCALAPPDATA%\AsistenteK2\logs.
  pause
)
exit /b %EXIT_CODE%