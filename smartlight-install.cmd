@echo off
setlocal

:: Pfad zum Dokumente-Verzeichnis via Windows API ermitteln
for /f "delims=" %%I in ('powershell -NoProfile -Command "[Environment]::GetFolderPath('MyDocuments')"') do set "DOCS_DIR=%%I"

:: Jetzt sicher in den Ordner wechseln
cd /d "%DOCS_DIR%\DeinRepoName"
break

:: Pfad zum Arduino-Ordner definieren
set "PROJECT_DIR=WI-Schnuppertag"
set "TARGET_DIR=%USERPROFILE%\Documents\Arduino\%TARGET_DIR%"
:: HIER DIE REPO-URL ANPASSEN
set "REPO_URL=https://github.com/wi-schnuppertage/smartlight.git"

:: HIER DEN NAMEN DEINER SKETCH-DATEI ANPASSEN (inkl. .ino)
:: Falls sie direkt im Hauptverzeichnis des Repos liegt, z.B. "MeinProjekt.ino"
set "SKETCH_NAME=01_Programmieren\01_Programmieren.ino"

echo %TARGET_DIR%
echo %SKETCH_NAME%

echo ===================================================
echo Starte Repository-Aktualisierung...
echo ===================================================

:: 1. Altes Verzeichnis loeschen, falls es existiert
if exist "%TARGET_DIR%" (
    echo Loesche alten Ordner: %TARGET_DIR%
    rmdir /s /q "%TARGET_DIR%"
)

:: 2. In den Arduino-Mutterordner wechseln
if not exist "%USERPROFILE%\Documents\Arduino" (
    mkdir "%USERPROFILE%\Documents\Arduino"
)
cd /d "%USERPROFILE%\Documents\Arduino"

:: 3. Repo frisch klonen
echo Klone Repository neu...
git clone "%REPO_URL%" %PROJECT_DIR%

if %ERRORLEVEL% equ 0 (
    echo.
    echo ===================================================
    echo Erfolg: Repository wurde erfolgreich aktualisiert!
    echo ===================================================
    
    :: 4. Arduino IDE mit dem Sketch starten
    echo Starte Arduino IDE...
    if exist "PROJECT_DIR\01_Programmieren\%SKETCH_NAME%" (
        start "" "PROJECT_DIR\%SKETCH_NAME%"
    ) else (
        echo HINWEIS: Die Datei %SKETCH_NAME% wurde im Hauptordner des Repos nicht gefunden.
    )
    
) else (
    echo.
    echo ---------------------------------------------------
    echo FEHLER: Beim Klonen ist etwas schiefgelaufen.
    echo Ist Git installiert und die URL korrekt?
    echo ---------------------------------------------------
)

:: Ein kurzes Timeout statt "pause", damit sich das Fenster 
:: nach 3 Sekunden von selbst schliesst, wenn alles geklappt hat
timeout /t 3