import 'package:biketheft_berlin/controller/csv_download_controller.dart';
import 'package:biketheft_berlin/controller/data_sources_controller.dart';
import 'package:biketheft_berlin/controller/location_controller.dart';
import 'package:biketheft_berlin/general_provider.dart';
import 'package:biketheft_berlin/widgets/get_location_button.dart';
import 'package:biketheft_berlin/widgets/map_zoom_buttons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;

final mapControllerMoveProvider = StateProvider<MapController>((ref) {
  return MapController();
});

class MapWidget extends ConsumerWidget {
  final LatLng centerLatLng = LatLng(52.51784, 13.406815);
  final _selectedPolygon;
  MapWidget(this._selectedPolygon);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final polygons = watch(polygonProvider);
    final location = watch(locationControllerProvider);
    final _mapController = context.read(mapControllerMoveProvider).state;
    final _zoomButtonsState = watch(zoomButtonsControllerProvider);
    final _selectedLatLng = watch(locationMarkerProvider).state;

    LatLng currentLatLng;

    var markers = <Marker>[];
    final List<Polygon> _selectedPolygons =
        _selectedPolygon != null ? [_selectedPolygon] : [];
    currentLatLng = location.when(
      data: (Position? locData) {
        ///_selectedLatLng holds the point which onTap yields
        if (locData != null) {
          final _currLatLng = LatLng(locData.latitude, locData.longitude);

          /// move map iff tapped point is the same as point of user locaton
          /// -> ensure onTap functon and getLocation function are working independently
          if (_currLatLng == _selectedLatLng) {
            _mapController.move(_currLatLng, 7);
          }

          /// override previous marker via insert
          markers.insert(
            0,
            Marker(
              width: 80.0,
              height: 80.0,
              point: _currLatLng,
              builder: (ctx) => Container(
                child: LocationMarker(),
              ),
            ),
          );
          return _currLatLng;
        } else {
          return _selectedLatLng ?? centerLatLng;
        }
      },
      error: (e, _) => LatLng(52.51784, 13.406815), // better print error
      loading: () => LatLng(52.51784, 13.406815),
    );

    /// for tapping otherwise use selectedPolygonProvider?
    void selectedPolygon(_, LatLng point) {
      try {
        context.read(locationMarkerProvider).state = point;
        currentLatLng = point;
        print(point);
        // _mapController.move(point, _mapController.zoom);
      } on StateError catch (_) {
        print("not in LOR");
      }
    }

    // define a custom CRS for Europe
    var resolutions = <double>[
      128,
      64,
      32,
      16,
      8,
      4,
      2,
      1,
    ];
    var epsg25833CRS = Proj4Crs.fromFactory(
      code: 'EPSG:25833',
      proj4Projection: proj4.Projection.get('EPSG:25833') ??
          proj4.Projection.add(
            'EPSG:25833',
            '+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ',
          ),
      resolutions: resolutions,
    );

    return polygons.when(
      data: (polyDat) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
              onTap:
                  selectedPolygon, // on Tap kann verwendet werden um ein popup an der Stelle anzuzeige
              minZoom: 1.0,
              maxZoom: resolutions.length - 1,
              zoom: 3.0,
              crs: epsg25833CRS,
              center: currentLatLng,
              // bounds: LatLngBounds(
              //     LatLng(52.6596, 13.1314), LatLng(52.2794, 13.6489)),
              plugins: _zoomButtonsState ? [MapZoomButtonsPlugin()] : []),
          layers: [
            TileLayerOptions(
              attributionBuilder: (_) {
                return Text(
                  "© OpenStreetMap contributors",
                  style: TextStyle(fontSize: 12),
                );
              },
              wmsOptions: WMSTileLayerOptions(
                  crs: epsg25833CRS,
                  baseUrl: "https://ows.terrestris.de/osm/service?",
                  format: 'image/jpeg',
                  layers: ['OSM-WMS']),
            ),
            MarkerLayerOptions(markers: markers),
            PolygonLayerOptions(
              polygons: _selectedPolygons,
            ),
          ],
          nonRotatedLayers: _zoomButtonsState
              ? [
                  MapZoomButtonsPluginOption(
                    minZoom: 1,
                    maxZoom: resolutions.length - 1,
                    mini: false,
                    padding: 18,
                    alignment: Alignment.topLeft,
                  ),
                ]
              : [],
          nonRotatedChildren: <Widget>[GetLocationButton()],
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text(
          e.toString(),
        ),
      ),
    );
  }
}

class LocationMarker extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[300]!.withOpacity(0.7),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class TapPosition {}
