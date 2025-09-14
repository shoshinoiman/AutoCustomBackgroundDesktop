@echo off
setlocal enableextensions

set "URL=https://raw.githubusercontent.com/TsofnatMaman/autoCustomBackgroundDesktop/main/script1.ps1"
set "PSSCRIPT=%APPDATA%\Microsoft\Windows\script1.ps1"

echo Downloading latest script...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $ErrorActionPreference='Stop'; Invoke-WebRequest -Uri '%URL%' -OutFile '%PSSCRIPT%' -UseBasicParsing" || (
  echo ERROR: download failed
  pause
  exit /b 1
)

if not exist "%PSSCRIPT%" (
  echo ERROR: script not found after download: %PSSCRIPT%
  pause
  exit /b 1
)

:: בדיקת אדמין (fltmc דורש אדמין)
>nul 2>&1 fltmc
if errorlevel 1 (
  echo Elevating to Administrator (UAC)...
  rem חלון PowerShell מורם, נשאר פתוח (NoExit) שתראי פלט
  powershell -NoProfile -Command ^
    "Start-Process PowerShell -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-NoExit','-File','""%PSSCRIPT%""' -Wait"
  echo (Elevated window closed)
) else (
  echo Already elevated. Running here...
  powershell -NoProfile -ExecutionPolicy Bypass -NoExit -File "%PSSCRIPT%"
)

pause
endlocal
