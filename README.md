Berlin-bike-theft-warning is a simple application which informs the user about the number of stolen bicycles either by location or by tapping.
It utilizes Riverpod/Provider for State Management and OSM Tiles.

## Packages
- `flutter_riverpod` for state management
- `hive` as local database
- `hive_flutter` extension for hive
- `csv` converts csv to nested lists
- `geolocator` handles realtime location in iOS and Android
- `flutter_maps` A Dart implementation of Leaflet for Flutter apps.
`proj4dart` needed for custom CRS 


Data sources:
https://daten.berlin.de/datensaetze/fahrraddiebstahl-berlin
https://daten.odis-berlin.de/  

#### Header CSV Fahrraddiebstähle
`ANGELEGT_AM,TATZEIT_ANFANG_DATUM,TATZEIT_ANFANG_STUNDE,TATZEIT_ENDE_DATUM,TATZEIT_ENDE_STUNDE,LOR,SCHADENSHOEHE,VERSUCH,ART_DES_FAHRRADS,DELIKT,ERFASSUNGSGRUND
`

<img alt="Initial Location/Map Center" src="fastlane\metadata\android\en-US\images\phoneScreenshots\Screenshot_1633969471.png" width="400"/>
<img alt="Initial Location Bar Chart" src="fastlane\metadata\android\en-US\images\phoneScreenshots\Screenshot_1633969479.png" width="400"/>

The Floating Action Button is color coded.  
Green: more than 20 bike thefts below average.  
Yellow: less than 20 bike thefts below/above average.  
Red: more than 20 bike thefts above average.  
<img alt="Floating Button is color coded" src="fastlane\metadata\android\en-US\images\phoneScreenshots\Screenshot_1633969488.png" width="400"/>
<img alt="Bar Chart" src="fastlane\metadata\android\en-US\images\phoneScreenshots\Screenshot_1633969494.png" width="400"/>  
By pressing the button a bar chart will pop up.


TODO:
- [ ] Functionality is as advertised. Though the app declares requesting ACCESS_FINE_LOCATION, this is not accessed automatically, nor when browsing the map – but only when told by the user to use the current location, which is very good. Unfortunately, it cannot be toggled off again without killing the app – which a future release will hopefully fix.
- [ ] TextButton Styling
- [ ] implement 'Strassenverkehr'
