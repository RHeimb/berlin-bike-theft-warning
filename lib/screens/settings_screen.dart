import 'package:bikedata_berlin/controller/app_theme_controller.dart';
import 'package:bikedata_berlin/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _appThemeControllerProvider =
        watch(appThemeControllerProvider.notifier);
    final _zoomButtonControllerProvider =
        watch(zoomButtonsControllerProvider.notifier);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(),
                  ),
                ),
                child: Text('Toogle App Theme'),
                onPressed: () =>
                    _appThemeControllerProvider.toggleAppTheme(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(),
                  ),
                ),
                child: Text('Toogle Zoom Buttons'),
                onPressed: () =>
                    _zoomButtonControllerProvider.toogleZoomButtons(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
