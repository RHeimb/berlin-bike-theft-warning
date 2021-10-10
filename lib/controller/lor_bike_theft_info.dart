import 'package:biketheft_berlin/controller/csv_download_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// final selectedLORProvider = StateProvider<String?>((ref) {
//   return null;
// });

// final selectedLorBikeTheftState = StateProvider<List<dynamic>?>((ref) {
//   return null;
// });
//family!!!

/// Return all rows that correspond to a given LOR Code
final lorBikeTheftInfoProvider =
    FutureProvider.family<List<dynamic>?, String?>((ref, lor) async {
  final csvList = await ref.watch(csvListProvider.future);
  if (lor != null && csvList != null) {
    // print(csvList.where((row) => row.contains(int.parse(lor))).toList());

    ///test for data visualization
    // List<dynamic> lorCsv = csvList.where((row) => row.contains(int.parse(lor))).toList();
    // // print(lorCsv);
    // Map<String, int> theftDates = {};

    //evtl reduce?
    // take just the month and the year
    // for (List<dynamic> l in lorCsv) {
    //   String monthAndYear = [l[0].split('.')[1], l[0].split('.')[2]].join('.');
    //   print(monthAndYear);
    //   if (theftDates.containsKey(monthAndYear)) {
    //     theftDates[monthAndYear] = theftDates.update(monthAndYear, (v) => v + 1);
    //   } else {
    //     theftDates[monthAndYear] = 1;
    //   }
    // }
    // print(theftDates);

    // String date = theftDates.keys.first;
    // List<int?> d = date.split('.').map((str) => int.tryParse(str)).toList();
    // if (d.any((v) => v != null)) {
    //   // var dt = DateTime(d[2]!, d[1]!, d[0]!);
    // }

    // print(date.split('.'));

    ///
    return csvList.where((row) => row.contains(int.parse(lor))).toList();
  } else {
    return [];
  }
});

/// 542 LORs in Berlin
/// ~35000 Thefts
/// = 65 per LOR average = x
/// Color code LORs by thefts:
/// green:  more than 10 less than 65
/// yellow 65 +- 10
/// red: above

final theftsColorCodeProvider =
    FutureProvider.family<Color?, String?>((ref, lor) async {
  final lorList = await ref.watch(lorBikeTheftInfoProvider(lor).future);
  final int avg = 65;
  if (lor != null && lorList != null) {
    if (lorList.length <= avg - 20) {
      return Colors.green.shade300;
    } else if (lorList.length > avg - 20 && lorList.length <= avg + 20) {
      return Colors.yellow.shade200;
    } else {
      return Colors.red.shade200;
    }
  } else {
    return null;
  }
});

class LorBikeTheftInfo {}
