@echo off
setlocal enableextensions

:: ===== CONFIG =====
set "URL=https://raw.githubusercontent.com/TsofnatMaman/autoCustomBackgroundDesktop/main/script1.ps1"
set "PSSCRIPT=%APPDATA%\Microsoft\Windows\script1.ps1"
set "VBS=%APPDATA%\Microsoft\Windows\run_wallpaper_bootstrap.vbs"
if not exist "%APPDATA%\Microsoft\Windows" mkdir "%APPDATA%\Microsoft\Windows" >nul 2>&1
:: ==================

echo [BOOT] Downloading latest script from: %URL%
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $ErrorActionPreference='Stop'; Invoke-WebRequest -Uri '%URL%' -OutFile '%PSSCRIPT%' -UseBasicParsing"

if not exist "%PSSCRIPT%" (
  echo [BOOT][ERROR] Failed to download script.
  pause
  exit /b 1
)

echo [BOOT] Creating VBS launcher at: %VBS%
> "%VBS%" echo Set sh = CreateObject("Wscript.Shell")
>>"%VBS%" echo sh.Run "powershell -NoProfile -ExecutionPolicy Bypass -NoExit -File ""%PSSCRIPT%""", 1, True

echo [BOOT] Launching elevated PowerShell via VBS...
cscript //nologo "%VBS%"

echo.
echo [BOOT] Script finished. Press any key to exit this window.
pause
endlocal
