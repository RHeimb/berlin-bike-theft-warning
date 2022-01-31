import 'package:biketheft_berlin/controller/lor_bike_accidents_info.dart';
import 'package:biketheft_berlin/controller/lor_bike_theft_info.dart';
import 'package:biketheft_berlin/plot_provider.dart';
import 'package:biketheft_berlin/screens/plot_accidents_fl.dart';
import 'package:biketheft_berlin/screens/plot_thefts_to_report_date_fl.dart';
import 'package:biketheft_berlin/screens/settings_screen.dart';
import 'package:biketheft_berlin/widgets/chart_box.dart';
import 'package:biketheft_berlin/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../general_provider.dart';

class MapScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final modus = watch(modusStateProvider); // 0=Thefts, 1=Accidents
    final lorCode = watch(selectedLorProvider).state?.item1;
    final title = watch(selectedLorProvider).state?.item2;
    final selectedPolygon = watch(selectedLorProvider).state?.item3;
    final color = watch(theftsColorCodeProvider(lorCode));

    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 78.0,
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () =>
                      modus.state == 1 ? modus.state = 0 : modus.state = 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        modus.state == 0 ? Icons.pedal_bike : Icons.traffic,
                      ),
                      modus.state == 0 ? Text('Diebstähle') : Text('Unfälle'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButtonTheme.of(context).style,
                  onPressed: () => showModalBottomSheet(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0),
                    context: context,
                    builder: (BuildContext context) {
                      return ChartBox(
                        title: title,
                        chartWidget: modus.state == 0
                            ? PlotTheftsToReportDateFl()
                            : PlotAccidentsFl(),
                      );
                    },
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: modus.state == 1
                            ? Colors.black
                            : color.when(
                                data: (color) => color,
                                loading: () {
                                  return Theme.of(context).primaryColor;
                                },
                                error: (error, stackTrace) =>
                                    Theme.of(context).primaryColor,
                              ),
                      ),
                      modus.state == 0
                          ? Text(
                              'Anzahl Diebstähle',
                              textAlign: TextAlign.center,
                            )
                          : Text('Anzahl der Radunfälle',
                              textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButtonTheme.of(context).style,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings,
                      ),
                      Text(
                        'Einstellungen',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: MapWidget(selectedPolygon),
                  flex: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
