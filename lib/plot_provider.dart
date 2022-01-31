import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Line from raw data:
// [10.07.2020, 09.07.2020, 16, 10.07.2020, 9, 1100310, 438, Nein, Herrenfahrrad, Fahrraddiebstahl, Sonstiger schwerer Diebstahl von Fahrrädern]

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

class AccidentsToHour {
  final int hour;
  final int accidents;
  AccidentsToHour({required this.hour, required this.accidents});
}

final itemCountProvider = StateProvider<int>((ref) => 30);
final chartIdProvider = StateProvider<int?>((ref) => 0);

final chartDropdownString = StateProvider<String>((ref) {
  final _id = ref.watch(chartIdProvider);
  switch (_id.state) {
    case 0:
      return 'Monatlich';
    case 1:
      return 'Täglich';
    default:
      return 'Monatlich';
  }
});

// To provide suitable items for the provided plot
final chartDropdownItemsProvider = StateProvider<List<int?>?>((ref) {
  final _id = ref.watch(chartIdProvider);
  switch (_id.state) {
    case 0:
      return [6, 12, null];
    case 1:
      return [7, 14, null];
    default:
      return [6, 12, null];
  }
});

final chartTimeSpanStateProvider = StateProvider<int?>((ref) => null);

// Es wird kein FutureProviderf benötigt, da der Chart nur im "whenData"-Case gebaut wird.
/// For charts_flutter lib

// OBJECTID;LAND;BEZ;LOR;LOR_ab_2021;UJAHR;UMONAT;USTUNDE;UWOCHENTAG;UKATEGORIE;...
final accidentsHourChartDataFl =
    Provider.family<LineChartBarData, List<dynamic>?>((ref, lorCsvList) {
  Map<int, int> accidentsHour = {};
  //evtl reduce?
  // take just the month and the year
  for (var l in lorCsvList!) {
    final hour = l[7];
    // print(monthAndYear);
    if (accidentsHour.containsKey(hour)) {
      accidentsHour[hour] =
          accidentsHour.update(hour, (v) => v == 0 ? v + 2 : v + 1);
    } else {
      accidentsHour[hour] = 0;
    }
  }

  List<AccidentsToHour> tl = [];
  for (int hour in accidentsHour.keys) {
    int? accidents = accidentsHour[hour];
    tl.add(new AccidentsToHour(hour: hour, accidents: accidents!));
  }

  List<FlSpot> linebarSpotData = [];
  for (AccidentsToHour item in tl) {
    // print('Stunde: ${item.hour} und Unfälle: ${item.accidents}');
    linebarSpotData
        .add(FlSpot(item.hour.toDouble(), item.accidents.toDouble()));
  }
  // sort the dates from latest to earliest
  // barChartGroupData.sort((a, b) => b.x.compareTo(a.x));
  linebarSpotData.sort((a, b) => a.x.compareTo(b.x));
  return LineChartBarData(
      spots: linebarSpotData,
      colors: [Colors.blueAccent],
      barWidth: 3,
      preventCurveOverShooting: true,
      belowBarData: BarAreaData(show: true),
      isCurved: true,
      dotData: FlDotData(
        show: false,
      ));
});

/// for fl_chart lib
final monthlyTheftsToReportDateChartDataFl =
    Provider.family<List<BarChartGroupData>, List<dynamic>?>((ref, lorCsvList) {
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

  List<BarChartGroupData> barChartGroupData = [];
  for (TheftsToReportDate item in tl) {
    // to get the date as required int and to make sorting easier
    final int reportDateInMs = item.reportDate.millisecondsSinceEpoch;
    BarChartGroupData bar = BarChartGroupData(
      x: reportDateInMs,
      barRods: [
        BarChartRodData(
            y: item.thefts.toDouble(), colors: [Colors.white70], width: 12),
      ],
    );
    barChartGroupData.add(bar);
  }
  // sort the dates from latest to earliest
  barChartGroupData.sort((a, b) => b.x.compareTo(a.x));

  return barChartGroupData;
});

final dailyTheftsToReportDateChartDataFl =
    Provider.family<List<BarChartGroupData>, List<dynamic>?>((ref, lorCsvList) {
  Map<String, int> theftDates = {};

  // take every day
  for (var l in lorCsvList!) {
    String day =
        [l[0].split('.')[0], l[0].split('.')[1], l[0].split('.')[2]].join('.');
    if (theftDates.containsKey(day)) {
      theftDates[day] = theftDates.update(day, (v) => v + 1);
    } else {
      theftDates[day] = 1;
    }
  }

  //alle Datumsfelder erst zu List<int> und dann zu DateTime casten -> dann Liste von TheftsToReportDate erstellen
  List<TheftsToReportDate> tl = [];
  for (var dateString in theftDates.keys) {
    List<int?> d =
        dateString.split('.').map((str) => int.tryParse(str)).toList();
    if (d.any((v) => v != null)) {
      DateTime dt = new DateTime(d[2]!, d[1]!, d[0]!);
      int? thefts = theftDates[dateString];
      tl.add(new TheftsToReportDate(reportDate: dt, thefts: thefts!));
    }
  }

  List<BarChartGroupData> barChartGroupData = [];
  print(tl.length);
  for (TheftsToReportDate item in tl) {
    // to get the date as required int and to make sorting easier
    final int reportDateInMs = item.reportDate.millisecondsSinceEpoch;
    BarChartGroupData bar = BarChartGroupData(
      x: reportDateInMs,
      barRods: [
        BarChartRodData(
          y: item.thefts.toDouble(),
          colors: [Colors.white70],
          width: 12,
        ),
      ],
    );
    barChartGroupData.add(bar);
  }
  // sort the dates from latest to earliest
  barChartGroupData.sort((a, b) => b.x.compareTo(a.x));

  return barChartGroupData;
});
