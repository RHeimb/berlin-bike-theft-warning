import 'package:biketheft_berlin/controller/data_sources_controller.dart';
import 'package:biketheft_berlin/controller/location_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import 'utils/is_point_in_polygon.dart';

// final selectedPolygonProvider = StateProvider<Polygon?>((ref) => null);

/// set LOR Code(1) and LOR name(2) and the corresponding Polygon(3) for building the chart widgets
final selectedLorProvider =
    StateProvider<Tuple3<String?, String?, Polygon>?>((ref) {
  var polygons = ref.watch(polygonProvider);
  var m = ref.read(lorHashMapProvider).state;
  var point = ref.watch(locationMarkerProvider).state;
  if (polygons.data != null) {
    Polygon _selectedPolygon =
        polygons.data!.value.firstWhere((p) => pointInPolygon(point, p));
    // ref.read(selectedPolygonProvider).state = _selectedPolygon;
    return Tuple3(m[_selectedPolygon.hashCode]!.elementAt(1),
        m[_selectedPolygon.hashCode]!.elementAt(0), _selectedPolygon);
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
