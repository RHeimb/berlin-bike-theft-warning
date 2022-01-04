import 'package:biketheft_berlin/plot_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TheftsPerDayBarChart extends ConsumerWidget {
  TheftsPerDayBarChart({
    Key? key,
    required this.seriesList,
  }) : super(key: key);

  final List<BarChartGroupData> seriesList;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _timeframe = watch(chartTimeSpanStateProvider);
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        groupsSpace: 2,
        alignment: BarChartAlignment.spaceEvenly,
        barGroups: seriesList.sublist(0, _timeframe.state ?? 30),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              rod.y.toString(),
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            );
          }),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(
            showTitles: false,
          ),
          leftTitles: SideTitles(
            reservedSize: 10,
            showTitles: true,
            interval: 1,
            margin: 1,
            getTextStyles: (context, value) =>
                Theme.of(context).textTheme.subtitle2,
          ),
          bottomTitles: SideTitles(
            rotateAngle: 30,
            showTitles: true,
            reservedSize: 16,
            getTextStyles: (context, value) =>
                Theme.of(context).textTheme.subtitle2,
            margin: 5,
            getTitles: (double value) {
              final DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
              final String isoDateString = date.toIso8601String();
              final List<String> dateStringList = isoDateString.split('-');

              return ('${dateStringList[2].substring(0, 2)}.${dateStringList[1]}');
            },
          ),
        ),
      ),
    );
  }
}