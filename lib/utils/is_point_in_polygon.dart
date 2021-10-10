import 'dart:math';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Translated from PHP
/// by https://github.com/MichalMisiaszek, thanks btw!
/// Source: https://assemblysys.com/php-point-in-polygon-algorithm/
bool pointInPolygon(LatLng? position, Polygon? polygon) {
  // Check if the point sits exactly on a vertex
  try {
    LatLng? vertexPosition =
        polygon?.points.firstWhere((LatLng? point) => point == position);
    if (vertexPosition != null) {
      return true;
    }
  } on StateError catch (_) {}

  // Check if the point is inside the polygon or on the boundary
  int intersections = 0;
  var verticesCount = polygon!.points.length;

  for (int i = 1; i < verticesCount; i++) {
    LatLng vertex1 = polygon.points[i - 1];
    LatLng vertex2 = polygon.points[i];

    // Check if point is on an horizontal polygon boundary
    if (vertex1.latitude == vertex2.latitude &&
        vertex1.latitude == position!.latitude &&
        position.longitude > min(vertex1.longitude, vertex2.longitude) &&
        position.longitude < max(vertex1.longitude, vertex2.longitude)) {
      return true;
    }

    if (position!.latitude > min(vertex1.latitude, vertex2.latitude) &&
        position.latitude <= max(vertex1.latitude, vertex2.latitude) &&
        position.longitude <= max(vertex1.longitude, vertex2.longitude) &&
        vertex1.latitude != vertex2.latitude) {
      var xinters = (position.latitude - vertex1.latitude) *
              (vertex2.longitude - vertex1.longitude) /
              (vertex2.latitude - vertex1.latitude) +
          vertex1.longitude;
      if (xinters == position.longitude) {
        // Check if point is on the polygon boundary (other than horizontal)
        return true;
      }
      if (vertex1.longitude == vertex2.longitude ||
          position.longitude <= xinters) {
        intersections++;
      }
    }
  }

  // If the number of edges we passed through is odd, then it's in the polygon.
  return intersections % 2 != 0;
}
