import 'package:biketheft_berlin/controller/location_controller.dart';
import 'package:biketheft_berlin/services/custom_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

class GetLocationButtonPluginOption extends LayerOptions {
  final double padding;
  final Alignment alignment;
  final Color? color;
  final IconData icon;

  GetLocationButtonPluginOption({
    Key? key,
    this.padding = 2.0,
    this.alignment = Alignment.bottomRight,
    this.color,
    this.icon = Icons.location_searching_rounded,
    Stream<Null>? rebuild,
  }) : super(key: key, rebuild: rebuild);
}

class GetLocationButtonPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is GetLocationButtonPluginOption) {
      return GetLocationButton(options, mapState, stream);
    }
    throw Exception('Unknown options type for ZoomButtonsPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is GetLocationButtonPluginOption;
  }
}

/// Button. Shows Snackbar on Permission error
class GetLocationButton extends ConsumerWidget {
  final GetLocationButtonPluginOption getLocationButtonPluginOption;
  final MapState map;
  final Stream<Null> stream;
  final FitBoundsOptions options =
      const FitBoundsOptions(padding: EdgeInsets.all(20.0));

  GetLocationButton(this.getLocationButtonPluginOption, this.map, this.stream)
      : super(key: getLocationButtonPluginOption.key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final location = watch(locationControllerProvider);
    LatLng markerPos;
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
          alignment: getLocationButtonPluginOption.alignment,
          child: IconButton(
              icon: Icon(getLocationButtonPluginOption.icon),
              padding: EdgeInsets.all(getLocationButtonPluginOption.padding),
              color: getLocationButtonPluginOption.color ??
                  Theme.of(context).primaryColor,
              onPressed: () async {
                context
                    .read(locationControllerProvider.notifier)
                    .getLocation()
                    .whenComplete(() => location.when(
                          data: (Position? locData) {
                            if (locData != null) {
                              final _currLatLng =
                                  LatLng(locData.latitude, locData.longitude);
                              markerPos = _currLatLng;
                              context.read(locationMarkerProvider).state =
                                  _currLatLng;
                              map.move(_currLatLng, 7,
                                  source: MapEventSource.custom);
                              map.rebuildLayers();
                            } else {
                              // markerPos = map.center;
                              // context.read(locationMarkerProvider).state = map.center;
                              // map.move(map.center, 7, source: MapEventSource.custom);
                            }
                          },
                          error: (e, _) {
                            context.read(locationErrorProvider).state =
                                CustomException(message: e.toString());
                          }, // better print error
                          loading: () => Center(
                            child: CircularProgressIndicator(),
                          ),
                        ));
              }),
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
