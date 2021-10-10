import 'package:flutter_test/flutter_test.dart';
import 'package:proj4dart/proj4dart.dart';

void main() {
  test('bl', () {
    var pointSrc = Point(x: 13.4118833, y: 52.5167867);
    var projSrc = Projection.get('EPSG:4326')!;
    var projDst = Projection.get('EPSG:25833') ??
        Projection.add(
          'EPSG:25833',
          '+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ',
        );

    var pointForward = projSrc.transform(projDst, pointSrc);
    print(
        'FORWARD: Transform point ${pointSrc.toArray()} from EPSG:4326 to EPSG:23700: ${pointForward.toArray()}');
    var lat = 52.5185917;
  });
}
