# Projekt-Architektur

Aufteilung in 3 Hauptlayer:

- Frontlayer
  - Reine UI/ Darstellung
    - Seiten und Widgets
    - Darstellung von Modellen und Werten 
      - zB. price = 3.5 darstellen als '€ 3,50'
    - Themedata
- Midlayer
  - Sämtliche Logik
    - Modellklassen
    - Provider/ Notifier
    - Utility-Funktionen
- Backlayer
  - Datenspeicherung
  - Kommunikation mit DB etc.
  - Reines sperichern und laden, keine Logik!

# Ordnerstruktur (lib)
- lib
    - front_layer
      - widgets
        => einzelne Widgets (zB. Snack- Item, Zahlenpad, etc.)
      - views
        => vollständige Seiten (zB Automaten-Ansicht, Admin-Ansicht)
    - mid-layer
      - models
      - states?
      - notifiers
      - providers.dart
      - weitere logik...
    - back_layer
      - DatabaseService
  - main.dart



# Prinzipieller Dataflow:
(So in etwa)

Input via UI 
=> Midlayer (ML) wird informiert 
=> ML fragt entsprechende Daten von DB an, verarbeitet diese und gibt eventuelle Änderungen an DB zurück 
=> ML updatet states und informiert den Frontlayer

## Beispiel:
User drückt Taste für Snack 'Nuka Cola'
=> UI informiert Midlayer 'Nuka Cola Taste gedrückt'
=> ML fragt Daten über 'Nuka Cola' bei der DB an.
    => count: 3
    => price: 3.5
=> ML updated den State des Automaten-Displays
=> Display zeigt an: 'Gewähltes Produkt: Nuka Cola (verfügbar), Preis: € 3,50'

# State Management
- Unterscheidung zwischen persistenten und runtime-States
- ### Runtime:
  - Im allgemeinen der 'Bedienungs'- State des Automaten
    - Aktueller Bezahlstand
    - Ausgewählter Snack
    - Beziehungen zwischen States über den virtuellen Input des Automaten
      - Snack wählen
      - Münzeinwurf
      - Rückgabeknopf
      - (ggf Automat schütteln?)
- ### Persistent
  - Überwiegend der State des Automaten-Inventars
    - Wie viele von welchen Snacks sind gerade vorrätig?
    - Wie viele von welchen Münzen sind gerade vorrätig?
      - Umfasst nur die Münzen, die tatsächlich gerade im Tresor des Automaten liegen, nicht die, die gerade erst eingeworfen wurden
