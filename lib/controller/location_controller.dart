import 'package:biketheft_berlin/services/custom_exception.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:geolocator/geolocator.dart';

final locationMarkerProvider =
    StateProvider<LatLng?>((ref) => LatLng(52.51784, 13.406815));
final locationErrorProvider = StateProvider<CustomException?>((ref) {
  return null;
});

final locationControllerProvider =
    StateNotifierProvider<LocationController, AsyncValue<Position?>>((ref) {
  return LocationController(ref.read);
});

// In order to request location, you should always check Location Service status and Permission status manually

class LocationController extends StateNotifier<AsyncValue<Position?>> {
  final Reader _read;
  // final Geolocator location = Geolocator();
  LocationController(this._read) : super(AsyncValue.data(null));

  Future<void> getLocation() async {
    try {
      final Position _location = await Geolocator.getCurrentPosition();
      if (mounted) {
        /// so that the latlng point is available independable from the onTouch method
        _read(locationMarkerProvider).state =
            LatLng(_location.latitude, _location.longitude);
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
