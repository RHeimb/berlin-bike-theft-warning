import 'package:biketheft_berlin/controller/lor_bike_accidents_info.dart';
import 'package:biketheft_berlin/plot_provider.dart';
import 'package:biketheft_berlin/size_helpers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChartBox extends ConsumerWidget {
  ChartBox({
    Key? key,
    required this.title,
    required this.chartWidget,
  }) : super(key: key);

  final String? title;
  final Widget chartWidget;
  final _scrollController = ScrollController();
  final _charts = [0, 1];
  final Map<int, String?> chartIdToName = {0: 'Monatlich', 1: 'Täglich'};

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final selectedChart = watch(chartIdProvider);
    final timeinterval = watch(chartTimeSpanStateProvider);
    final dropDownItems = watch(chartDropdownItemsProvider);
    final chartNames = watch(chartDropdownString);
    final modus = watch(modusStateProvider); // 0=Thefts, 1=Accidents

    // print(timeinterval.state);
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    title ?? 'Tap!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
                chartWidget,
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Zurück',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          modus.state == 1
                              ? Container()
                              : DropdownButton<int>(
                                  hint: Text(
                                    chartNames.state,
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  items: _charts.map((chart) {
                                    return DropdownMenuItem<int>(
                                      value: chart,
                                      child: Text(
                                        chartIdToName[chart]!,
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                    );
                                  }).toList(),
                                  // icon: const Icon(Icons.arrow_downward),
                                  onChanged: (int? newVal) {
                                    timeinterval.state = null;
                                    selectedChart.state = newVal;
                                  },
                                ),
                        ],
                      ),
                      Column(
                        children: [
                          modus.state == 1
                              ? Container()
                              : DropdownButton<int>(
                                  style: Theme.of(context).textTheme.button,
                                  value: timeinterval.state,
                                  hint: Text(
                                    'Zeitintervall',
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  items: dropDownItems.state?.map((interval) {
                                    return DropdownMenuItem<int>(
                                      value: interval,
                                      child: selectedChart.state == 0
                                          ? Text(
                                              '${interval ?? 'Alle'.toString()} Monate',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button,
                                            )
                                          : Text(
                                              '${interval ?? 'Alle'.toString()} Tage',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button,
                                            ),
                                    );
                                  }).toList(),
                                  // icon: const Icon(Icons.arrow_downward),
                                  onChanged: (int? newVal) {
                                    timeinterval.state = newVal;
                                  },
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
