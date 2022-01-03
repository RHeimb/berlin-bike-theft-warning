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
`proj4dart` needed for custom CRS 

Data sources:
https://daten.berlin.de/datensaetze/fahrraddiebstahl-berlin
https://daten.odis-berlin.de/

<img alt="Initial Location/Map Center" src="fastlane\metadata\android\en-US\images\phoneScreenshots\Screenshot_1633969471.png" width="400"/>
<img alt="Initial Location Bar Chart" src="fastlane\metadata\android\en-US\images\phoneScreenshots\Screenshot_1633969479.png" width="400"/>

The Floating Action Button is color coded.  
Green: more than 20 bike thefts below average.  
Yellow: less than 20 bike thefts below/above average.  
Red: more than 20 bike thefts above average.  
<img alt="Floating Button is color coded" src="fastlane\metadata\android\en-US\images\phoneScreenshots\Screenshot_1633969488.png" width="400"/>
<img alt="Bar Chart" src="fastlane\metadata\android\en-US\images\phoneScreenshots\Screenshot_1633969494.png" width="400"/>  
By pressing the button a bar chart will pop up.


