Berlin-bike-theft-warning
-------------------------

Berlin-bike-theft-warning is a simple application which informs the user about the number of stolen bicycles either by location or by tapping.

It utilizes Riverpod/Provider for State Management and OSM Tiles.

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png"
     alt="Get it on F-Droid"
     height="80">](https://f-droid.org/packages/de.example.fahrraddiebstahl_berlin/)

## Packages
- `flutter_riverpod` for state management
- `hive` as local database
- `hive_flutter` extension for hive
- `csv` converts csv to nested lists
- `geolocator` handles realtime location in iOS and Android
- `flutter_maps` A Dart implementation of Leaflet for Flutter apps.
- `proj4dart` needed for custom CRS


Data sources:
https://daten.berlin.de/datensaetze/fahrraddiebstahl-berlin
https://daten.odis-berlin.de/  
https://daten.berlin.de/datensaetze/strassenverkehrsunf%C3%A4lle-nach-unfallort-berlin-2020  


#### Header CSV Fahrraddiebstähle
`ANGELEGT_AM,TATZEIT_ANFANG_DATUM,TATZEIT_ANFANG_STUNDE,TATZEIT_ENDE_DATUM,TATZEIT_ENDE_STUNDE,LOR,SCHADENSHOEHE,VERSUCH,ART_DES_FAHRRADS,DELIKT,ERFASSUNGSGRUND
`

<img alt="Initial Location/Map Center" src="fastlane\metadata\android\en-US\images\phoneScreenshots\1.png" width="400"/>
<img alt="Initial Location Bar Chart" src="fastlane\metadata\android\en-US\images\phoneScreenshots\2.png" width="400"/>

The button is color coded.  
Green: more than 20 bike thefts below average.  
Yellow: less than 20 bike thefts below/above average.  
Red: more than 20 bike thefts above average.  
<img alt="Button is color coded" src="fastlane\metadata\android\en-US\images\phoneScreenshots\4.png" width="400"/>
<img alt="Accidents Chart" src="fastlane\metadata\android\en-US\images\phoneScreenshots\3.png" width="400"/>  
By pressing the button a bar chart will pop up.


TODO:
- [ ] Functionality is as advertised. Though the app declares requesting ACCESS_FINE_LOCATION, this is not accessed automatically, nor when browsing the map – but only when told by the user to use the current location, which is very good. Unfortunately, it cannot be toggled off again without killing the app – which a future release will hopefully fix.
- [x] Button Styling
- [x] implement 'Strassenverkehr'
- [ ] make a usable ui
