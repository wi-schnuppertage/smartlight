@echo off
setlocal
title WI-Schnuppertag

:: =====================================================================
:: Startet die Schulung mit einem frischen Template.
:: 1. Laedt den aktuellen Stand des Repos als ZIP (kein Git noetig)
:: 2. Ohne Internet: verwendet den zuletzt geladenen Stand
:: 3. Fuehrt Install\install.ps1 aus dem Repo aus
:: Diese Datei aendert sich nie. Alle Logik liegt im Repo.
:: =====================================================================

set "REPO=wi-schnuppertage/smartlight"
:: Branch: heads/main   Tag: tags/stable
set "REF=heads/main"

set "CACHE=%LOCALAPPDATA%\WI-Schnuppertag"
set "ZIP=%TEMP%\wi-template.zip"
set "TMPX=%TEMP%\wi-template"
set "PS1=%CACHE%\repo\Install\install.ps1"

echo Lade aktuelles Template...

if exist "%TMPX%" rmdir /s /q "%TMPX%"
mkdir "%TMPX%"

curl -fsSL --connect-timeout 10 -o "%ZIP%" "https://github.com/%REPO%/archive/refs/%REF%.zip" || goto :offline
tar -xf "%ZIP%" -C "%TMPX%" || goto :offline

set "NEW="
for /d %%D in ("%TMPX%\*") do set "NEW=%%D"
if not defined NEW goto :offline
if not exist "%NEW%\Install\install.ps1" goto :offline

:: Neuen Stand einsetzen, alten erst nach Erfolg loeschen
if not exist "%CACHE%" mkdir "%CACHE%"
if exist "%CACHE%\repo.old" rmdir /s /q "%CACHE%\repo.old"
if exist "%CACHE%\repo" move "%CACHE%\repo" "%CACHE%\repo.old" >nul
if exist "%CACHE%\repo" goto :offline
move "%NEW%" "%CACHE%\repo" >nul
if errorlevel 1 (
    if exist "%CACHE%\repo.old" move "%CACHE%\repo.old" "%CACHE%\repo" >nul
    goto :offline
)
if exist "%CACHE%\repo.old" rmdir /s /q "%CACHE%\repo.old"
goto :run

:offline
if exist "%PS1%" (
    echo [WARNUNG] Download nicht moeglich. Verwende zuletzt geladenen Stand.
    goto :run
)
echo [FEHLER] Download fehlgeschlagen und kein lokaler Stand vorhanden.
echo Bitte Internetverbindung pruefen.
pause
exit /b 1

:run
del "%ZIP%" >nul 2>&1
rmdir /s /q "%TMPX%" >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" -Launcher "%~f0"
if errorlevel 1 (
    echo.
    echo [FEHLER] Installation fehlgeschlagen. Log: %TEMP%\wi-install.log
    pause
    exit /b 1
)
exit /b 0
