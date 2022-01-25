import 'package:biketheft_berlin/controller/lor_bike_accidents_info.dart';
import 'package:biketheft_berlin/general_provider.dart';
import 'package:biketheft_berlin/plot_provider.dart';
import 'package:biketheft_berlin/widgets/accidents_hour_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlotAccidentsFl extends ConsumerWidget {
  // final List<charts.Series<TheftsToReportDate, DateTime>> seriesList = useProvider(PlotTheftsToReportDate);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var lor;
    var errorMsg = Text('Kein Kiez ausgewählt');
    try {
      lor = watch(selectedLorProvider).state?.item1;
    } on ProviderException {
      lor = null;
      errorMsg = Text('Nicht im Stadtbereich');
    }
    final csv = watch(lorBikeAccidentsInfoProvider);

    return csv.when(
        data: (lorData) {
          if (lorData == null) {
            return Center(
              child: errorMsg,
            );
          } else {
            final seriesList = watch(accidentsHourChartDataFl(lorData));
            return AccidentsHourLineChart(seriesList: seriesList);
          }

          // return TheftsPerMonthBarChart(seriesList: seriesList);
        },
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (e, _) => Center(
              child: Text(e.toString()),
            ));
  }
}
