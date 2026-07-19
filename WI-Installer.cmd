@echo off
setlocal
cls

echo ------------------------------------------------------------------
echo ------------------------------------------------------------------
echo             Starte WI-Schnuppertag Installation...
echo ------------------------------------------------------------------
echo ------------------------------------------------------------------
echo.
timeout /t 3 >nul

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
set "SKETCH_NAME=01_Programmieren\01_Programmieren.ino"

:: Der Prozessname mit Leerzeichen
set "PROZESSNAME=Arduino IDE.exe"

:: Pruefen, ob der Arduino IDE.exe Prozess laeuft
tasklist /FI "IMAGENAME eq %PROZESSNAME%" 2>NUL | find /I "%PROZESSNAME%" >NUL

if "%ERRORLEVEL%" neq 0 (
    echo %PROZESSNAME% ist gestartet und muss beendet werden
    echo Beende %PROZESSNAME%...
	timeout /t 3 >nul
    REM Arduino-IDE.exe beenden
	taskkill /F /IM "%PROZESSNAME%" /T >nul 2>&1
)

:: 1. Altes Verzeichnis loeschen, falls es existiert
if exist "%TARGET_DIR%" (
    echo Loesche alten Projektordner: %TARGET_DIR%
    rmdir /s /q "%TARGET_DIR%"
)

:: 2. In den Arduino-Mutterordner wechseln
if not exist "%DOCS_DIR%\Arduino" (
    mkdir "%DOCS_DIR%\Arduino"
)
cd /d "%DOCS_DIR%\Arduino"

:: 3. Repo frisch klonen
echo.
echo ------------------------------------------------------------------
echo Klone Repository neu...
echo ------------------------------------------------------------------

git clone "%REPO_URL%" %PROJECT_DIR%
timeout /t 3 >nul

if %ERRORLEVEL% equ 0 (
    :: 4. Arduino IDE mit dem Sketch starten
    echo.
    echo ------------------------------------------------------------------
    echo Starte Arduino IDE...
    echo ------------------------------------------------------------------
	timeout /t 3 >nul
    if exist "%PROJECT_DIR%\%SKETCH_NAME%" (
		powershell -Command "Start-Process '%PROJECT_DIR%\%SKETCH_NAME%' -WindowStyle Hidden"
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

timeout /t 3 >nul