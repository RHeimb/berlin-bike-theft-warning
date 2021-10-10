import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TheftsToHour {
  final int thefts;
  final int startHour;
  final int endHour;
  TheftsToHour(
      {required this.thefts, required this.startHour, required this.endHour});
}

class TheftsToReportDate {
  final DateTime reportDate;
  final int thefts;
  TheftsToReportDate({required this.reportDate, required this.thefts});
}

// Es wird kein FutureProviderf benötigt, da der Chart nur im "whenData"-Case gebaut wird.
/// For charts_flutter lib

/// for fl_chart lib
final theftsToReportDateChartDataFl =
    Provider.family<List<fl.BarChartGroupData>, List<dynamic>?>(
        (ref, lorCsvList) {
  Map<String, int> theftDates = {};

  //evtl reduce?
  // take just the month and the year
  for (var l in lorCsvList!) {
    String monthAndYear = [l[0].split('.')[1], l[0].split('.')[2]].join('.');
    // print(monthAndYear);
    if (theftDates.containsKey(monthAndYear)) {
      theftDates[monthAndYear] = theftDates.update(monthAndYear, (v) => v + 1);
    } else {
      theftDates[monthAndYear] = 1;
    }
  }

  //alle Datumsfelder erst zu List<int> und dann zu DateTime casten -> dann Liste von TheftsToReportDate erstellen
  List<TheftsToReportDate> tl = [];
  for (var dateString in theftDates.keys) {
    List<int?> d =
        dateString.split('.').map((str) => int.tryParse(str)).toList();
    if (d.any((v) => v != null)) {
      DateTime dt = new DateTime(d[1]!, d[0]!);
      int? thefts = theftDates[dateString];
      tl.add(new TheftsToReportDate(reportDate: dt, thefts: thefts!));
    }
  }

  List<fl.BarChartGroupData> barChartGroupData = [];
  for (TheftsToReportDate item in tl) {
    // to get the date as required int and to make sorting easier
    final int reportDateInMs = item.reportDate.millisecondsSinceEpoch;
    fl.BarChartGroupData bar = fl.BarChartGroupData(
      x: reportDateInMs,
      barRods: [
        fl.BarChartRodData(y: item.thefts.toDouble(), colors: [Colors.white70]),
      ],
    );
    barChartGroupData.add(bar);
  }
  // sort the dates from earliest to latest
  barChartGroupData.sort((a, b) => a.x.compareTo(b.x));
  return barChartGroupData;
});
