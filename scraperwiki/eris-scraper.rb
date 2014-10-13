#!/usr/bin/env ruby

# ein kleiner scraper für das ratsinformations-system der stadt leipzig
# mit scraperwiki: https://scraperwiki.com
#

# bibliotheken laden
require 'scraperwiki'
require 'nokogiri'   # <- eine bibliothek zum komfortablen arbeiten mit HTML dokumenten

#
# ein paar hilfsfunktionen
#

# extrahiert die daten aus einer einzelnen tabellenzeile
def parse_row(row)
    cells = row.css('td')
    return nil if cells.nil?

    {
        "volfdnr"   => extract_id(cells[0]),
        "title"     => extract_text(cells[1]),
        "presenter" => extract_text(cells[3]),
        "date"      => extract_text(cells[4]),
        "type"      => extract_text(cells[5])
    }
end

# extrahiert die VOLFDNR aus einer tabellenzelle
def extract_id(cell)
    return nil if cell.nil?
    input   = cell.css('input[@name="VOLFDNR"]').first
    return nil if input.nil?
    volfdnr = input["value"]
end

# extrahiert den text aus den tabellenzellen
def extract_text(cell)
    return nil if cell.nil?
    cell.text
end

#
# der eigentliche scraper teil
#

# 1. daten laden
html = ScraperWiki.scrape("https://ratsinfo.leipzig.de/bi/vo040.asp?showall=true")
page = Nokogiri::HTML(html)

# 2. zeilen extrahieren
rows = page.css('table.tl1 tbody tr')

data = rows.map do |row|
    next if row.nil?
    parse_row(row)
end

# 3. Daten speichern

unique_keys = [ 'volfdnr' ]

data.each do |record|
  next if record["volfdnr"].nil?
  ScraperWiki.save_sqlite(unique_keys, record)
end

# .. und dann sollten die daten im interface von scraperwiki verfügbar sein.
#
# zum abschluss noch ein paar links:
#
# einführung in die ruby syntax:
#
#   https://www.ruby-lang.org/de/documentation/quickstart/
#
#
# die scraperwiki bibliothek (zur lokalen installation):
#
#   https://github.com/scraperwiki/scraperwiki-ruby
#
#
# die seite der nokogiri bibliothek (zum arbeiten mit HTML dokumenten):
#
#   http://www.nokogiri.org/
#

