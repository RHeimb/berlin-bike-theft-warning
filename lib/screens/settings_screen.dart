import 'package:biketheft_berlin/controller/app_theme_controller.dart';
import 'package:biketheft_berlin/services/csv_download_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../general_provider.dart';

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(),
                  ),
                ),
                child: Text('Datensatz überprüfen'),
                onPressed: () => MetadataDialog.show(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetadataDialog extends HookWidget {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MetadataDialog(),
    );
  }

  const MetadataDialog();

  @override
  Widget build(BuildContext context) {
    final csvBox = useProvider(csvBoxProvider);
    final String? dataTimestamp = csvBox.get('lastModified').toString();

    return SafeArea(
      maintainBottomViewPadding: true,
      child: AspectRatio(
        aspectRatio: 4 / 8,
        child: Card(
          color: Theme.of(context).primaryColor,
          margin: EdgeInsets.fromLTRB(40, 180, 40, 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dataTimestamp ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Zurück'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
