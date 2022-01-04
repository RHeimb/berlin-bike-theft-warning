import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccidentsHourLineChart extends ConsumerWidget {
  AccidentsHourLineChart({
    Key? key,
    required this.seriesList,
  }) : super(key: key);

  final LineChartBarData seriesList;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return LineChart(LineChartData(
        borderData: FlBorderData(show: false),
        axisTitleData: FlAxisTitleData(
          show: true,
          bottomTitle: AxisTitle(showTitle: true, titleText: 'Uhrzeit'),
          leftTitle: AxisTitle(showTitle: true, titleText: 'Anzahl Unfälle'),
        ),
        lineBarsData: [
          seriesList,
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            reservedSize: 10,
            interval: 1,
            showTitles: true,
            getTextStyles: (context, value) =>
                Theme.of(context).textTheme.subtitle2,
          ),
          topTitles: SideTitles(
            interval: 1,
            showTitles: false,
            getTextStyles: (context, value) =>
                Theme.of(context).textTheme.subtitle2,
          ),
          leftTitles: SideTitles(
            interval: 1,
            showTitles: true,
            getTextStyles: (context, value) =>
                Theme.of(context).textTheme.subtitle2,
          ),
          rightTitles: SideTitles(
            interval: 1,
            showTitles: false,
            getTextStyles: (context, value) =>
                Theme.of(context).textTheme.subtitle2,
          ),
        )));
  }
}
