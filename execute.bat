@echo off
setlocal enableextensions

:: --- CONFIG ---
set "URL=https://raw.githubusercontent.com/TsofnatMaman/autoCustomBackgroundDesktop/main/script1.ps1"
set "PSSCRIPT=%APPDATA%\Microsoft\Windows\script1.ps1"
set "VBS=%TEMP%\run_wallpaper_elevated.vbs"
if not exist "%APPDATA%\Microsoft\Windows" mkdir "%APPDATA%\Microsoft\Windows" >nul 2>&1

:: Download latest script (quiet)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -Uri '%URL%' -OutFile '%PSSCRIPT%' -UseBasicParsing -ErrorAction Stop } catch { exit 1 }"
if errorlevel 1 exit /b 1

:: Create one-shot VBS that launches elevated & hidden, then run it and exit
> "%VBS%" echo Set sh = CreateObject("Shell.Application")
>>"%VBS%" echo sh.ShellExecute "powershell.exe", "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""%PSSCRIPT%""", "", "runas", 0

wscript //nologo "%VBS%"

endlocal
exit /b
