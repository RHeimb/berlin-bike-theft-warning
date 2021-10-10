import 'package:bikedata_berlin/controller/data_sources_controller.dart';
import 'package:bikedata_berlin/controller/location_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/is_point_in_polygon.dart';

final chartNameProvider = StateProvider<String?>((ref) {
  var polygons = ref.watch(polygonProvider);
  var m = ref.watch(lorHashMapProvider).state;
  var point = ref.watch(locationMarkerProvider).state;
  if (polygons.data != null) {
    return m[polygons.data!.value
            .firstWhere((p) => pointInPolygon(point, p))
            .hashCode]!
        .elementAt(0);
  } else {
    return null;
  }
});

/// set LOR Code and LOR name for building the chart widgets
final selectedLorProvider = StateProvider<String?>((ref) {
  var polygons = ref.watch(polygonProvider);
  var m = ref.read(lorHashMapProvider).state;
  var point = ref.watch(locationMarkerProvider).state;
  if (polygons.data != null) {
    return m[polygons.data!.value
            .firstWhere((p) => pointInPolygon(point, p))
            .hashCode]!
        .elementAt(1);
  } else {
    return null;
  }
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  //The return type Future<SharedPreferences> isn’t a ‘SharedPreferences’, as required by the closure’s context
  //Code Reference: https://codewithandrea.com/videos/flutter-state-management-riverpod
  throw UnimplementedError();
});

final sharedUtilityProvider = Provider<SharedUtility>((ref) {
  final _sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SharedUtility(sharedPreferences: _sharedPrefs);
});

class SharedUtility {
  SharedUtility({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  /// Theme
  bool isDarkModeEnabled() {
    return sharedPreferences.getBool("isDarkModeEnabled") ?? false;
  }

  Future<bool> setDarkModeEnabled(bool value) async {
    return await sharedPreferences.setBool("isDarkModeEnabled", value);
  }

  /// Zoom Buttons
  bool areZoomButtonsEnabled() {
    return sharedPreferences.getBool('areZoomButtonsEnabled') ?? false;
  }

  Future<bool> setZoomButtonsEnabled(bool value) async {
    return await sharedPreferences.setBool('areZoomButtonsEnabled', value);
  }
}

final zoomButtonsControllerProvider =
    StateNotifierProvider<ZoomButtonsNotifier, bool>(
  (ref) {
    final __areZoomButtonsEnabled =
        ref.read(sharedUtilityProvider).areZoomButtonsEnabled();
    return ZoomButtonsNotifier(__areZoomButtonsEnabled);
  },
);

class ZoomButtonsNotifier extends StateNotifier<bool> {
  ZoomButtonsNotifier(this.defaultZoomButtonValue)
      : super(defaultZoomButtonValue);
  final bool defaultZoomButtonValue;

  toogleZoomButtons(BuildContext context) {
    final _areZoomButtonsEnabled =
        context.read(sharedUtilityProvider).areZoomButtonsEnabled();
    final _toogleValue = !_areZoomButtonsEnabled;
    context
        .read(sharedUtilityProvider)
        .setZoomButtonsEnabled(_toogleValue)
        .whenComplete(
          () => {state = _toogleValue},
        );
  }
}
