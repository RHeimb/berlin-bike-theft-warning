import 'package:bikedata_berlin/services/custom_exception.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

final locationMarkerProvider =
    StateProvider<LatLng?>((ref) => LatLng(52.5185917, 13.405555));
final locationErrorProvider = StateProvider<CustomException?>((ref) {
  return null;
});

final locationControllerProvider =
    StateNotifierProvider<LocationController, AsyncValue<LocationData?>>((ref) {
  return LocationController(ref.read);
});

// In order to request location, you should always check Location Service status and Permission status manually

class LocationController extends StateNotifier<AsyncValue<LocationData?>> {
  final Reader _read;
  final Location location = Location();
  LocationController(this._read) : super(AsyncValue.data(null));

  Future<void> getLocation() async {
    try {
      final LocationData _location = await location.getLocation();
      if (mounted) {
        // print(_location.latitude);
        // print(_location.longitude);

        /// so that the latlng point is available independable from the onTouch method
        _read(locationMarkerProvider).state =
            LatLng(_location.latitude!, _location.longitude!);
        // print(DateTime.fromMillisecondsSinceEpoch(_location.time!.toInt()));

        state = AsyncValue.data(_location);
      }
    } on PlatformException catch (_) {
      _read(locationErrorProvider).state = CustomException(
          message:
              'Location permission denied forever - please open app settings.');
    } catch (e) {
      _read(locationErrorProvider).state =
          CustomException(message: e.toString());
    }
  }
}
