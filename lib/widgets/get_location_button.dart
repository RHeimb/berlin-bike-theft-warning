import 'package:bikedata_berlin/controller/location_controller.dart';
import 'package:bikedata_berlin/services/custom_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// to Render the right chart on the bottomSheet I need following items/states:
/// 1.lorHashMap, which maps STR[LOR Code, LOR Name] to the Hashvalue of the Polygon. To provide
/// 3.selectedLORState, which is normally set via the flutter_map onTap method which takes a LatLng Point
/// 4.chartNameState. Same as above
/// 2.the LatLng Point from the location set by pressing the GetLocationData
///
/// Button. Shows Snackbar on Permission error

class GetLocationButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final title = watch(selectedLorProvider);
    final location = watch(locationControllerProvider);

    return location.when(
      data: (userLocation) => ProviderListener(
        provider: locationErrorProvider,
        onChange: (
          BuildContext context,
          StateController<CustomException?> customException,
        ) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(customException.state!.message!),
            ),
          );
        },
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 18.0, bottom: 18),
            child: ElevatedButton(
              child: Icon(
                Icons.location_searching_rounded,
                color: IconTheme.of(context).color,
              ),
              onPressed: () {
                context.read(locationControllerProvider.notifier).getLocation();
              },
            ),
          ),
        ),
      ),
      error: (e, _) => Center(
        child: Text(
          e.toString(),
        ),
      ),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
