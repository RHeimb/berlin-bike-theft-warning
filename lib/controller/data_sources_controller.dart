import 'dart:async';
import 'dart:math';
import 'package:biketheft_berlin/services/custom_exception.dart';
import 'package:biketheft_berlin/services/geojson_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geojson/geojson.dart';
import 'package:geopoint/geopoint.dart';
import 'package:simplify/simplify.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;

final dataSourcesExceptionProvider =
    StateProvider<CustomException?>((ref) => null);

final geoJsonStringProvider = FutureProvider<String?>((ref) async {
  final geoJsonString = await ref
      .read(geoJsonServiceProvider)
      .readGeoJson(path: 'assets/lor_planungsraeume_2021.json');

  return geoJsonString;
});

/// Maps Prpoerties from GEOJson as List of Strings to the Hash of a Polygon
final lorHashMapProvider = StateProvider<Map<int, List<String>>>((ref) => {});

final polygonProvider =
    StateNotifierProvider<PolygonController, AsyncValue<List<Polygon>>>(
  (ref) {
    return PolygonController(ref.read);
  },
);

class PolygonController extends StateNotifier<AsyncValue<List<Polygon>>> {
  final Reader _read;
  final polygons = <Polygon>[];
  PolygonController(this._read) : super(AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    return await _read(geoJsonStringProvider.future)
        .then((json) => _loadJsonData(json));
  }

  Future<void> _loadJsonData(String? data) async {
    final geoJson = GeoJson();
    final Map<int, List<String>> lorHashMap = {};
    geoJson.parse(data!);
    final features = geoJson.features;
    int i = 0;
    geoJson.processedMultiPolygons.listen((GeoJsonMultiPolygon multiPolygon) {
      for (final polygon in multiPolygon.polygons) {
        // print(features[i].properties!.entries.toList()[1].value);

        final geoSerie = GeoSerie(
          type: GeoSerieType.polygon,
          name: polygon.geoSeries[0].name,
          geoPoints: <GeoPoint>[],
        );
        for (final serie in polygon.geoSeries) {
          if (serie.geoPoints != null) {
            /// EPSG:25833 -> EPSG:4326 for.each.point.
            List<Point> points = serie.geoPoints
                .map((p) => Point(p.longitude, p.latitude))
                .toList();
            List<Point> simplifiedPoints = simplify(points, tolerance: 5.0);
            List<GeoPoint> newList =
                simplifiedPoints.map((p) => toDegree(p)).toList();
            // newList.forEach((p) => print(p.latitude));

            geoSerie.geoPoints.addAll(newList);
          }
        }
        final color =
            // Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
            Colors.blue.shade400.withOpacity(0.6);
        final poly = Polygon(
            points: geoSerie.toLatLng(ignoreErrors: true),
            color: color,
            isDotted: true);

        /// Is there a better way to get the features of a Polygon from
        /// GEOJson Multipolygon data?
        lorHashMap[poly.hashCode] = [
          /// LOR Code
          features[i].properties!.entries.toList()[1].value,

          /// LOR Name
          features[i].properties!.entries.toList()[0].value
        ];
        polygons.add(poly);
        i += 1;
      }
      if (mounted) {
        // print(polygons);
        state = AsyncValue.data(polygons);

        /// make the hashmap accessable globally via StateProvider
        _read(lorHashMapProvider).state.addAll(lorHashMap);
      }
    });
  }

  GeoPoint toDegree(Point point) {
    var pointSrc = proj4.Point(x: point.x.toDouble(), y: point.y.toDouble());
    var projSrc = proj4.Projection.get('EPSG:25833') ??
        proj4.Projection.add(
          'EPSG:25833',
          '+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ',
        );
    var projDst = proj4.Projection.get('EPSG:4326')!;

    var newPoint = projSrc.transform(projDst, pointSrc);
    return GeoPoint(longitude: newPoint.x, latitude: newPoint.y);
  }
}
// class PloygonController extents StateNotifier<AsyncValue<List<Ploygon>>>{

// }
