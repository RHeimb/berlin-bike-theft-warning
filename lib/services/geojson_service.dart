import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geoJsonServiceProvider = Provider<GeoJsonService>((ref) => GeoJsonService());

class GeoJsonService {
  const GeoJsonService();

  Future<String?> readGeoJson({required String path}) async {
    return await rootBundle.loadString(path).then((json) => json);
  }
}
