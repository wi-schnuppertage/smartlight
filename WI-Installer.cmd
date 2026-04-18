@echo off
setlocal

:: Prüfen, ob git im PATH vorhanden ist
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ------------------------------------------------------------------
    echo FEHLER: Git ist nicht installiert oder nicht im PATH gefunden.
    echo Bitte installiere zuerst Git von https://git-scm.com/install/
    echo ------------------------------------------------------------------
    pause
    exit /b
)

:: Pfad zum Dokumente-Verzeichnis via Windows API ermitteln
for /f "delims=" %%I in ('powershell -NoProfile -Command "[Environment]::GetFolderPath('MyDocuments')"') do set "DOCS_DIR=%%I"

:: Pfad zum Arduino-Ordner definieren
set "PROJECT_DIR=WI-Schnuppertag"
set "TARGET_DIR=%DOCS_DIR%\Arduino\%PROJECT_DIR%"

:: HIER DIE REPO-URL ANPASSEN
set "REPO_URL=https://github.com/wi-schnuppertage/smartlight.git"

:: HIER DEN NAMEN DEINER SKETCH-DATEI ANPASSEN (inkl. .ino)
:: Falls sie direkt im Hauptverzeichnis des Repos liegt, z.B. "MeinProjekt.ino"
set "SKETCH_NAME=01_Programmieren\01_Programmieren.ino"

echo ===================================================
echo Starte Repository-Aktualisierung...
echo ===================================================

:: 1. Altes Verzeichnis loeschen, falls es existiert
if exist "%TARGET_DIR%" (
    echo Loesche alten Ordner: %TARGET_DIR%
    rmdir /s /q "%TARGET_DIR%"
)

:: 2. In den Arduino-Mutterordner wechseln
if not exist "%DOCS_DIR%\Arduino" (
    mkdir "%DOCS_DIR%\Arduino"
)
cd /d "%DOCS_DIR%\Arduino"

:: 3. Repo frisch klonen
echo Klone Repository neu...
git clone "%REPO_URL%" %PROJECT_DIR%

if %ERRORLEVEL% equ 0 (
    for /l %%i in (1,1,5) do (
    cls
	color 0A
    echo.
    echo =================================================================
    echo -  INSTALLATION ERFOLGREICH!
    echo -  -------------------------------------------------------------
    echo -  Projekt wurde erfolgreich installiert.
    echo.
	echo -  Starte nun die Arduino-IDE um zu beginnen.
    echo =================================================================
    echo.
	timeout /t 1 >nul
	color 07
    timeout /t 1 >nul
	)

) else (
    echo.
    echo ---------------------------------------------------
    echo FEHLER: Beim Klonen ist etwas schiefgelaufen.
    echo Ist Git installiert und die URL korrekt?
    echo ---------------------------------------------------
)

timeout /t 3