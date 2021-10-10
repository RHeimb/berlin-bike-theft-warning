import 'package:bikedata_berlin/services/custom_exception.dart';
import 'package:bikedata_berlin/services/geojson_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geoJsonExceptionProvider = StateProvider<CustomException?>((ref) => null);

final geoJsonProvider = FutureProvider<String?>((ref) async {
  final geoJsonString = await ref.read(geoJsonServiceProvider).readGeoJson(path: 'assets/lor_planungsraeume_2021.json');
  return geoJsonString;
});

/// Nutzlos?
// class GeoJsonController extends StateNotifier<AsyncValue<String?>> {
//   final Reader _read;

//   GeoJsonController(this._read) : super(AsyncValue.loading()) {
//     getGeoJsonString();
//   }

//   Future<void> getGeoJsonString() async {
//     try {
//       final jsonString = await _read(geoJsonServiceProvider).readGeoJson(path: 'assets/lor_planungsraeume_2021.json');
//       if (mounted) {
//         state = AsyncValue.data(jsonString);
//       }
//     } on CustomException catch (e) {
//       print(e.message);
//       _read(geoJsonExceptionProvider).state = e;
//     }
//   }
// }
