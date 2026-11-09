# WI-Schnuppertag: Template zuruecksetzen und Arduino IDE starten
# Liegt im Repo unter Install\install.ps1. Nur ASCII verwenden.

param([string]$Launcher)

$ErrorActionPreference = 'Stop'

# === Einstellungen ===
$ProjectName = 'WI-Schnuppertag'
$SketchRel   = '01_Programmieren\01_Programmieren.ino'
$PdfRel      = '10_Dokumentation\WI-Schnupperprogramm.pdf'
$PdfLinkName = 'WI-Schnupperprogramm'   # Name der Verknuepfung (ohne .lnk)
$OpenPdf     = $false                   # $true: PDF beim Start automatisch oeffnen
# Nicht ins Template kopieren:
$Exclude     = @('.git', '.github', '.gitignore', '.gitattributes', 'images', 'Install', 'WI-Installer.cmd')

$RepoDir = Split-Path -Parent $PSScriptRoot

try { Start-Transcript -Path (Join-Path $env:TEMP 'wi-install.log') -Force | Out-Null } catch {}

Write-Host '=========================================' -ForegroundColor Cyan
Write-Host '  WI-Schnuppertag'                         -ForegroundColor Cyan
Write-Host '=========================================' -ForegroundColor Cyan

function Step([string]$t) { Write-Host ''; Write-Host $t -ForegroundColor Yellow }
function Ok([string]$t)   { Write-Host "  [OK] $t" -ForegroundColor Green }
function Warn([string]$t) { Write-Host "  [WARNUNG] $t" -ForegroundColor Yellow }

# Launcher (WI-Installer.cmd) aktualisieren, falls sich der Repo-Stand unterscheidet.
# Die Kopie laeuft verzoegert in einem eigenen Prozess, damit die laufende .cmd nicht ueberschrieben wird.
function Update-Launcher {
    if (-not $Launcher -or -not (Test-Path $Launcher)) { return }
    $new = Join-Path $RepoDir 'WI-Installer.cmd'
    if (-not (Test-Path $new)) { return }
    if (-not (Select-String -Path $new -Pattern 'install.ps1' -Quiet)) { return }
    if ((Get-FileHash $new).Hash -eq (Get-FileHash $Launcher).Hash) { return }
    $src = $new.Replace("'", "''")
    $dst = $Launcher.Replace("'", "''")
    $cmd = "Start-Sleep -Seconds 5; Copy-Item -LiteralPath '$src' -Destination '$dst' -Force"
    Start-Process powershell -WindowStyle Hidden -ArgumentList '-NoProfile', '-Command', $cmd
    Warn 'Launcher wird aktualisiert (gilt ab dem naechsten Start).'
}

# === 1. Arduino IDE schliessen (sonst Dateien gesperrt) ===
Step '[1/3] Arduino IDE schliessen'
$running = Get-Process -Name 'Arduino IDE' -ErrorAction SilentlyContinue
if ($running) {
    $running | Stop-Process -Force
    Start-Sleep -Seconds 2
    Ok 'geschlossen'
} else {
    Ok 'nicht geoeffnet'
}

# === 2. Template frisch kopieren ===
Step '[2/3] Template kopieren'
$Sketchbook = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Arduino'
$CliYaml = Join-Path $env:USERPROFILE '.arduinoIDE\arduino-cli.yaml'
if (Test-Path $CliYaml) {
    $line = Select-String -Path $CliYaml -Pattern '^\s*user:\s*(.+)$' | Select-Object -First 1
    if ($line) {
        $p = $line.Matches[0].Groups[1].Value.Trim().Trim('"').Trim("'")
        if ($p) { $Sketchbook = $p }
    }
}
$Target = Join-Path $Sketchbook $ProjectName

try {
    New-Item -ItemType Directory -Path $Sketchbook -Force | Out-Null
    if (Test-Path $Target) { Remove-Item -Path $Target -Recurse -Force }
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
    Get-ChildItem -Path $RepoDir -Force |
        Where-Object { $Exclude -notcontains $_.Name } |
        Copy-Item -Destination $Target -Recurse -Force
    Ok $Target
} catch {
    Write-Host "  [FEHLER] $_" -ForegroundColor Red
    Write-Host '  Sind Dateien des Projekts noch geoeffnet?'
    try { Stop-Transcript | Out-Null } catch {}
    exit 1
}

# === Bibliotheken (optional: Install\libraries\<Name>) ===
$LibSrc = Join-Path $PSScriptRoot 'libraries'
if (Test-Path $LibSrc) {
    $LibDst = Join-Path $Sketchbook 'libraries'
    foreach ($lib in Get-ChildItem -Path $LibSrc -Directory) {
        try {
            New-Item -ItemType Directory -Path $LibDst -Force | Out-Null
            $t = Join-Path $LibDst $lib.Name
            if (Test-Path $t) { Remove-Item -Path $t -Recurse -Force }
            Copy-Item -Path $lib.FullName -Destination $t -Recurse -Force
            Ok "Bibliothek $($lib.Name)"
        } catch { Warn "Bibliothek $($lib.Name): $_" }
    }
}

# === Verknuepfung zur PDF-Dokumentation (Desktop und Ordner der WI-Installer.cmd) ===
$PdfPath = Join-Path $Target $PdfRel
if (Test-Path $PdfPath) {
    $dirs = @([Environment]::GetFolderPath('Desktop'))
    if ($Launcher -and (Test-Path $Launcher)) { $dirs += (Split-Path -Parent $Launcher) }
    $done = @()
    foreach ($d in $dirs) {
        $key = $d.TrimEnd('\').ToLowerInvariant()
        if ($done -contains $key) { continue }
        $done += $key
        try {
            $link = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $d "$PdfLinkName.lnk"))
            $link.TargetPath = $PdfPath
            $link.WorkingDirectory = Split-Path -Parent $PdfPath
            $link.Save()
            Ok "Verknuepfung: $d"
        } catch { Warn "Verknuepfung in ${d}: $_" }
    }
} else {
    Warn "PDF nicht gefunden: $PdfPath"
}

Update-Launcher

# === 3. Arduino IDE starten ===
Step '[3/3] Arduino IDE starten'
$exe = @(
    "$env:LOCALAPPDATA\Programs\Arduino IDE\Arduino IDE.exe",
    "$env:ProgramFiles\Arduino IDE\Arduino IDE.exe",
    "${env:ProgramFiles(x86)}\Arduino IDE\Arduino IDE.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

$SketchPath = Join-Path $Target $SketchRel

if (-not $exe) {
    Warn 'Arduino IDE nicht gefunden. Bitte installieren und Sketch manuell oeffnen:'
    Write-Host "  $SketchPath"
    try { Stop-Transcript | Out-Null } catch {}
    Read-Host 'Enter zum Beenden'
    exit 0
}

$ideArgs = $null
if (Test-Path $SketchPath) {
    $ideArgs = "`"$SketchPath`""
} else {
    Warn "Sketch nicht gefunden: $SketchPath"
    Start-Sleep -Seconds 3
}

Write-Host ''
Write-Host 'Fertig. Arduino IDE wird gestartet.' -ForegroundColor Green
try { Stop-Transcript | Out-Null } catch {}

# Konsole loesen, damit sich das Fenster nach dem Start der IDE schliesst.
# Sonst halten die IDE und ihre Hilfsprozesse das Fenster offen.
try {
    Add-Type -Namespace WI -Name Native -MemberDefinition '[DllImport("kernel32.dll")] public static extern bool FreeConsole();'
    [void][WI.Native]::FreeConsole()
} catch {}

if ($OpenPdf -and (Test-Path $PdfPath)) { Start-Process -FilePath $PdfPath }
if ($ideArgs) { Start-Process -FilePath $exe -ArgumentList $ideArgs } else { Start-Process -FilePath $exe }
exit 0
