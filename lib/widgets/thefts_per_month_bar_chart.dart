import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TheftsPerMonthBarChart extends HookWidget {
  TheftsPerMonthBarChart({
    Key? key,
    required this.seriesList,
  }) : super(key: key);

  final List<BarChartGroupData> seriesList;

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      borderData: FlBorderData(show: false),
      groupsSpace: 1,
      alignment: BarChartAlignment.spaceEvenly,
      barGroups: seriesList,
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
          showTitles: true,
          interval: 1,
          margin: 1,
          getTextStyles: (context, value) =>
              const TextStyle(fontSize: 8, letterSpacing: 0),
        ),
        bottomTitles: SideTitles(
          rotateAngle: 30,
          showTitles: true,
          reservedSize: 14,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.normal,
            fontSize: 8,
          ),
          margin: 5,
          getTitles: (double value) {
            final DateTime date =
                DateTime.fromMillisecondsSinceEpoch(value.toInt());
            final String isoDateString = date.toIso8601String();
            final List<String> dateStringList = isoDateString.split('-');

            return ('${dateStringList[1]}.${dateStringList[0]}');
          },
        ),
      ),
    ));
  }
}
