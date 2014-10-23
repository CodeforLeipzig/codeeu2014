Workshop: Daten mit Python verarbeiten und visualisieren
========================================================

Autor: [Markus Zapke-Gründemann](http://www.keimlink.de/)

Ziel: Visualisierung der Beschäftigten- und Arbeitslosenzahlen für Leipzig

## Datenquellen

Zuerst die [CSV](https://de.wikipedia.org/wiki/CSV_%28Dateiformat%29) Dateien von der Website der Stadt Leipzig herunterladen:

* [Beschäftigte](http://statistik.leipzig.de/statdist/table.aspx?cat=7&rub=1&obj=0)
* [Arbeitslose](http://statistik.leipzig.de/statdist/table.aspx?cat=7&rub=2&obj=0)

Jeweils die Tabelle ohne Stadtbezirksdaten speichern, der Download-Link befindet sich ganz am Ende der Seite. Die Dateien umbennen in `beschaeftigte.csv` und `arbeitslose.csv`.

## Vorbereitung der Daten

Leider enthalten die CSV Datein am Ende [Nullzeichen](https://de.wikipedia.org/wiki/Nullzeichen). Es ist am einfachsten diese Zeile jeweils manuell zu löschen, sonst klappt der Verarbeiten des Daten nicht.

## Verarbeiten der CSV Dateien

Dafür kommt das [Python](https://www.python.org/) Modul [csv](https://docs.python.org/2.7/library/csv.html) zum Einsatz.

Erstelle eine neue Datei `parse_csv.py`. Dies ist der Code zum Einlesen und bilden der Summen für alle Ortsteile:

```python
# Laden des Moduls csv
import csv


# Oeffnen und Lesen der CSV Datei
with open('./beschaeftigte.csv') as csvfile:
    employed = csv.reader(csvfile, delimiter=';')
    # Jede Zeile einzeln verarbeiten
    for row in employed:
        # Sonderbehandlung der ersten Zeile und Erzeugen des dictionaries
        # mit den Jahren als Schluessel, aber die erste Zelle auslassen
        if row[0] == 'Gebiet':
            years = {}.fromkeys(row[1:], 0)
            # Sofort zur naechsten Zeile springen
            continue
        # Wert fuer jedes Jahr einzeln summieren
        for year, value in zip(years, row[1:]):
            years[year] += int(value)
```

Den Code kannst du mit `python parse_csv.py` ausführen.

Jetzt stehen in der Variable `years` die Summen für alle Jahre zur Verfügung. Um diese auszugeben kannst du am Ende der Datei den Befehl `print(years)` einfügen.

Der Code zum Schreiben der Daten in eine neue CSV Datei:

```python
# Oeffnen und Schreiben der neuen CSV Datei
with open('./beschaeftigte_summe.csv', 'wb') as csvfile:
    totals = csv.writer(csvfile, delimiter=',')
    # Titelzeile schreiben
    totals.writerow(['Beschaeftigte', 'Jahr'])
    # Jahreswerte schreiben
    totals.writerows(years.items())
```

Dieser erstellt eine neue CSV Datei `beschaeftigte_summe.csv`, die die Summen für alle Jahre enthält. Füge ihn am Ende der Datei `parse_csv.py` ein.

## Visualisierung der Daten im Browser

Zur Visualisierung kommt die [JavaScript](https://de.wikipedia.org/wiki/JavaScript) Bibliothek [dygraphs](http://dygraphs.com/) zum Einsatz.

Zuerst die Datei `dygraph-combined.js` [herunterladen](http://dygraphs.com/download.html) und im gleichen Verzeichnis speichern wie die Datei `beschaeftigte_summe.csv`, die du gerade erzeugt hast.

Erstele Dann eine neue Datei `index.html` und füge das [HTML](https://de.wikipedia.org/wiki/Hypertext_Markup_Language) aus dem ersten Beispiel des [dygraphs Tutorials](http://dygraphs.com/tutorial.html) ein. Dabei werden die CSV Daten durch den Namen der CSV Datei ersetzt. HTML und CSV Datei müssen sich im gleichen Verzeichnis befinden.

```html
<html>
<head>
    <script type="text/javascript"
      src="dygraph-combined.js"></script>
</head>
<body>
    <h2>Beschaeftigte in Leipzig</h2>
    <div id="graphdiv"></div>
    <script type="text/javascript">
      g = new Dygraph(
        // containing div
        document.getElementById("graphdiv"),
        // CSV or path to a CSV file.
        "beschaeftigte_summe.csv"
      );
    </script>
</body>
</html>

```

Nun startest du im dem Verzeichnis, dass CSV und HTML Dateien enthält, einen lokalen [Webserver](https://de.wikipedia.org/wiki/Webserver) mit Hilfe von Python. Denn sonst kann der JavaScript Code nicht die CSV Datei laden:

```
$ python -m SimpleHTTPServer
Serving HTTP on 0.0.0.0 port 8000 ...
```

Jetzt sollte beim Aufruf des URLs http://127.0.0.1:8000/ der Graph mit den Zahlen der Beschäftigten erscheinen.

Den Webserver kannst du mit der Tastenkomination `STRG + C` wieder beenden.

## Wie geht es weiter?

Versuche doch, auch die Zahlen der Arbeitslosen in das Diagramm zu bekommen! Alles, was du dafür brauchst hast du gerade gelernt. :-)
