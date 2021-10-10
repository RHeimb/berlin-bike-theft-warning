import 'package:bikedata_berlin/controller/lor_bike_theft_info.dart';
import 'package:bikedata_berlin/plot_provider.dart';
import 'package:bikedata_berlin/widgets/thefts_per_month_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../general_provider.dart';

class PlotTheftsToReportDateFl extends ConsumerWidget {
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
    final csv = watch(lorBikeTheftInfoProvider(lor));

    return csv.when(
        data: (lorData) {
          if (lorData!.isEmpty) {
            return Center(
              child: errorMsg,
            );
          } else {
            final seriesList = watch(theftsToReportDateChartDataFl(lorData));
            return TheftsPerMonthBarChart(seriesList: seriesList);
          }
        },
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (e, _) => Center(
              child: Text(e.toString()),
            ));
  }
}
