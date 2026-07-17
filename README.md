# WI-Schnuppertage - smartLight Projekt

<img align="left" width="250" height="250" alt="WI_smartLight" src="https://github.com/user-attachments/assets/022d695d-0bb5-44d9-b165-b75d83b62885" />

Willkommen beim Schnupperprojekt der HTL Anichstraße - Abteilung Wirtschaftsingenieure / Betriebsinformatik!

In diesem Projekt lernst du die Grundlagen der Programmierung mit einem ESP32-Mikrocontroller und einem LED-Ring mit 24 LEDs.

<br clear="left"/>

---

## Inhaltsverzeichnis

1. [Was brauchst du?](#1-was-brauchst-du)
2. [Software Installation - Schritt für Schritt](#2-software-installation---schritt-für-schritt)
   - [Schritt 1: Arduino IDE installieren](#schritt-1-arduino-ide-installieren)
   - [Schritt 2: ESP32 Board Support installieren](#schritt-2-esp32-board-support-installieren)
   - [Schritt 3: Board auswählen](#schritt-3-board-auswählen)
   - [Schritt 4: Adafruit NeoPixel Bibliothek installieren](#schritt-4-adafruit-neopixel-bibliothek-installieren)
3. [smartLight-Projekt herunterladen](#3-smartlight-projekt-herunterladen)
4. [Projekt öffnen und hochladen](#4-projekt-öffnen-und-hochladen)
5. [Programmieren lernen](#5-programmieren-lernen)
   - [Die wichtigsten Funktionen](#die-wichtigsten-funktionen)
   - [Beispiel-Code: Lauflicht](#beispiel-code-lauflicht)
6. [Häufige Probleme und Lösungen](#6-häufige-probleme-und-lösungen)
7. [Weitere Ressourcen](#7-weitere-ressourcen)
8. [Projekt-Info](#8-projekt-info)

---

## 1. Was brauchst du?

### Hardware
- **WI-smartLight Platine mit ESP32-Mikrocontroller und LED Ring** (mit USB-C-Kabel)

### Software
- **Arduino IDE** (Version 2.x empfohlen)
- **USB-Treiber** für ESP32 (unter Windows 11 normalerweise bereits installiert)

---

## 2. Software Installation - Schritt für Schritt

### Schritt 1: Arduino IDE installieren

1. Öffne deinen Browser und gehe zu: https://www.arduino.cc/en/software
2. Lade die aktuelle **Arduino IDE 2.x** für Windows herunter
3. Führe die heruntergeladene Installationsdatei aus
4. Folge dem Installationsassistenten (Standard-Einstellungen sind okay)
5. Starte die Arduino IDE nach der Installation

### Schritt 2: ESP32 Board Support installieren

1. Öffne die Arduino IDE
2. Gehe zu **Werkzeuge** → **Board** → **Boardverwalter...**
3. Suche nach **"esp32"**
4. Installiere **"esp32 by Espressif Systems"** (neueste Version)
5. Warte, bis die Installation abgeschlossen ist

### Schritt 3: Board auswählen

1. Schließe dein smartLight per USB-Kabel an den Computer an
2. Gehe zu **Werkzeuge** → **Board** → **lolin** → **LOLIN C3 Mini**
3. Gehe zu **Werkzeuge** → **Port** und wähle den COM-Port aus (z.B. COM3, COM4...)
   - *Hinweis: Wenn kein Port angezeigt wird, müssen eventuell USB-Treiber installiert werden*

### Schritt 4: Adafruit NeoPixel Bibliothek installieren

1. Gehe zu **Tools** → **Bibliotheken verwalten...**
2. Suche nach **"Adafruit NeoPixel"**
3. Installiere **"Adafruit NeoPixel"** von Adafruit
4. Warte, bis die Installation abgeschlossen ist

---

## 3. smartLight-Projekt herunterladen

1. Öffne deinen Browser (Chrome, Firefox, Edge...)
2. Gehe zu: **https://github.com/wi-schnuppertage/smartlight**
3. Klicke oben rechts auf den grünen Button **"<> Code"**
4. Im aufklappenden Menü: Klicke auf **"Download ZIP"**
5. Speichere die ZIP-Datei (sie heißt `smartlight-main.zip`)
6. Öffne deinen **Downloads**-Ordner
7. **Rechtsklick** auf die ZIP-Datei → **"Alle extrahieren..."**
8. Klicke auf **"Extrahieren"** (Standard-Einstellungen sind okay)
9. Es wird ein neuer Ordner **`smartlight-main`** erstellt
10. Kopiere den Ordner **WI-Schnuppertag** nach **Dokumente** → **Arduino**

---

## 4. Projekt öffnen und hochladen

1. Öffne die Arduino IDE.
2. Klicke links in der Navigationsleiste auf das Ordner-Symbol (Sketchbook)
3. Navigiere zu **WI-Schnuppertag** → **01_Programmieren**

Alternativ:
1. Gehe zu **Datei** → **Öffnen**.
2. Navigiere zu **Dokumente** → **Arduino** → **WI-Schnuppertag** → **01_Programmieren**.
3. Öffne **`01_Programmieren.ino`**.

### Code hochladen

1. Stelle sicher, dass dein smartLight angeschlossen ist
2. Wählen unter **Board** → **lolin** → **LOLIN C3 Mini**
3. Wähle unter **Port** den COM-Port aus (z.B. COM3, COM4...)
2. Klicke auf den **Upload-Button** (Pfeil nach rechts) oben links
3. Warte, bis der Code kompiliert und hochgeladen wird
4. In der Konsole sollte **"Hard resetting via RTS pin..."** erscheinen
5. Dein Programm läuft jetzt auf dem smartLight!

---

## 5. Programmieren lernen

### Datei-Struktur

Das Projekt, das unter `Dokumente/Arduino/WI-Schnuppertag` zu finden ist, enthält zwei Hauptordner:

**01_Programmieren** – Programmierübungen für Anfänger:
- **`01_Programmieren.ino`** – Hier programmierst du! Dein Hauptcode für erste Übungen mit dem LED-Ring.
- **`helper.h`** – Hilfsfunktionen und Hardware-Setup (NICHT BEARBEITEN!).

**02_Funktionstest** – Funktionstest für Platine:
- **`02_Funktionstest.ino`** – Code um die Funktionalität des WI-smartLight zu testen (grüne LED auf 6 Uhr).

---

### Die wichtigsten Funktionen

#### LED-Ring steuern

```cpp
// Farben definieren
int rot = ring.Color(255, 0, 0);
int gruen = ring.Color(0, 255, 0);
int blau = ring.Color(0, 0, 255);

// Einzelne LED einschalten (LED-Nummer 0-23, Rot, Grün, Blau)
ring.setPixelColor(0, rot);  // LED 0 wird rot
// oder auch
ring.setPixelColor(0, 255, 0, 0);  // LED 0 wird rot

// Alle LEDs aktualisieren (erforderlich um Änderungen anzuzeigen!)
ring.show();

// Alle LEDs ausschalten
ring.clear();
ring.show();

// Helligkeit ändern (0-255)
ring.setBrightness(50);

// Alle LEDs einschalten
ring.fill(blau)   // alle LEDs blau
ring.show();

// warten
delay(500)  // 0,5 Sekunden warten

ring.fill(gruen, 7, 5)   // ab LED 8 5 LEDs in blau einschalten
ring.show();
```

#### Farben definieren

```cpp
// RGB-Werte: Rot, Grün, Blau (jeweils 0-255)
ring.setPixelColor(0, 255, 0, 0);      // Rot
ring.setPixelColor(1, 0, 255, 0);      // Grün
ring.setPixelColor(2, 0, 0, 255);      // Blau
ring.setPixelColor(3, 255, 255, 0);    // Gelb
ring.setPixelColor(4, 255, 0, 255);    // Magenta
ring.setPixelColor(5, 0, 255, 255);    // Cyan
ring.setPixelColor(6, 255, 255, 255);  // Weiß
```

### Beispiel-Code: Lauflicht

```cpp
void setup() {
    ring.begin();           // LED-Ring initialisieren
    ring.setBrightness(20); // Helligkeit setzen
    ring.clear();           // Alle LEDs aus
    ring.show();            // Änderungen anzeigen
}

void loop() {
    if (updateErforderlich()) {
        ring.clear();
        
        // LED Nummer ist rest von step geteilt durch 24
        int aktuelleLED = step % 24;
        ring.setPixelColor(aktuelleLED, 0, 255, 0);  // Grün
        
        ring.show();
    }
}
```

---

## 6. Häufige Probleme und Lösungen

### Problem: "Port not found" oder kein COM-Port sichtbar

**Lösung:**
1. Überprüfe das USB-Kabel (manche Kabel können nur laden, nicht übertragen)
2. Installiere den USB-Treiber: https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers
3. Verwende einen anderen USB-Port
4. Starte den Computer neu

### Problem: "Compilation error" oder Fehler beim Kompilieren

**Lösung:**
1. Überprüfe, ob alle Bibliotheken installiert sind (Adafruit NeoPixel)
2. Stelle sicher, dass das richtige Board ausgewählt ist (LOLIN C3 Mini)
3. Überprüfe deinen Code auf Tippfehler (Semikolons, Klammern...)

### Problem: LEDs leuchten nicht

**Lösung:**
1. Überprüfe die Hardware-Verkabelung
2. Stelle sicher, dass `ring.show()` aufgerufen wird
3. Erhöhe die Helligkeit: `ring.setBrightness(50)`
4. Teste mit einem einfachen Beispiel:
   ```cpp
   void loop() {
       ring.setPixelColor(0, 255, 0, 0);
       ring.show();
   }
   ```

### Problem: Upload schlägt fehl "Failed to connect"

**Lösung:**
1. Halte den **BOOT-Button** auf dem ESP32 gedrückt
2. Klicke auf Upload
3. Lasse den Button los, wenn "Connecting..." erscheint

---

## 7. Weitere Ressourcen

- **Arduino Referenz:** https://www.arduino.cc/reference/de/
- **Adafruit NeoPixel Guide:** https://learn.adafruit.com/adafruit-neopixel-uberguide
- **ESP32 Dokumentation:** https://docs.espressif.com/projects/arduino-esp32/

---

## 8. Projekt-Info

**HTL Anichstraße, Innsbruck**  
Wirtschaftsingenieure - Betriebsinformatik  
WI-Schnuppertage 
© 2025 Andreas Eckhart

---

## Viel Erfolg!

Experimentiere mit verschiedenen Farben, Mustern und Animationen! Programmieren lernt man am besten durch ausprobieren.
