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


# Oeffnen und Schreiben der neuen CSV Datei
with open('./beschaeftigte_summe.csv', 'wb') as csvfile:
    totals = csv.writer(csvfile, delimiter=',')
    # Titelzeile schreiben
    totals.writerow(['Beschaeftigte', 'Jahr'])
    # Jahreswerte schreiben
    totals.writerows(years.items())
