import 'package:biketheft_berlin/controller/lor_bike_theft_info.dart';
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
    final lorCode = watch(selectedLorProvider).state?.item1;
    final title = watch(selectedLorProvider).state?.item2;
    final selectedPolygon = watch(selectedLorProvider).state?.item3;
    final color = watch(theftsColorCodeProvider(lorCode));

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: color.data?.value ?? Theme.of(context).primaryColor,
        onPressed: () => showModalBottomSheet(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
          context: context,
          builder: (BuildContext context) {
            return ChartBox(
                title: title, chartWidget: PlotTheftsToReportDateFl());
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(),
                      ),
                    )),
          ],
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
