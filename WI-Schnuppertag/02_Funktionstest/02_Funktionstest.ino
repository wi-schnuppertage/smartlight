/***********************************************************************************
 * Teil 1: Grundlagen
 * WI-Schnuppertage 2025 / 2026
 ***********************************************************************************
 * Einführung in die Programmierung mittels ESP32 und LED-Ring
 * HTL-Anichstrasse, Innsbruck
 * Wirtschaftsingenieure - Betriebsinformatik / (c)2025 Andreas Eckhart
 ***********************************************************************************/

#include "helper.h"   // Alle Hilfsfunktionen und Hardware-Definitionen

/***********************************************************************************
 * ✅ AB HIER KANNST DU BEARBEITEN! ✅
 ***********************************************************************************/

// Setup-Funktion - wird einmal beim Start ausgeführt
void setup() {
    // hier kommt der Setup-Code hin
    ring.setBrightness(BRIGHTNESS);
    ring.clear();
    ring.show();

}

// Loop-Funktion - wird ununterbrochen ausgeführt
void loop() {
    // hier kommt der Effekt-Code hin
    int gruen = ring.Color(0, 255, 0);
    ring.fill(gruen);
    ring.show();
}


/***********************************************************************************
 * hier kommt am Ende dein Effekt 1 hin - bis dahin einfach leer lassen
 ***********************************************************************************/
void deinEffekt1(int step) {

}