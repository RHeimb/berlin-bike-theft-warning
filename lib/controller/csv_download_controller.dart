import 'dart:io';
import 'package:bikedata_berlin/services/csv_download_service.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final buildListNotificationProvider = StateProvider<String?>((ref) => null);

final csvListProvider = FutureProvider<List<dynamic>?>((ref) async {
  var csvBox = Hive.box('csvBox');
  final csvDownloadService = ref.watch(csvDownloadServiceProvider);
  final List<dynamic>? listFromBox = await csvBox.get("latestList");

  try {
    if (listFromBox == null) {
      final list = await csvDownloadService.getLatestCsvList();
      ref.read(buildListNotificationProvider).state =
          'Die Daten werden heruntergeladen und verarbeitet.\nDauert...';
      await csvBox.put('latestList', list);
      return list;
    } else {
      print("return list from hivebox");
      final list = listFromBox;
      return list;
    }
  } on FileSystemException {
    ref.read(buildListNotificationProvider).state =
        'Die Daten werden heruntergeladen und verarbeitet.\nDauert...';

    final list = await ref
        .watch(csvDownloadServiceProvider)
        .saveCsvToDevice()
        .then((_) => ref.read(csvDownloadServiceProvider).getLatestCsvList());
    print("from CsvListController: " + list.length.toString());
    await csvBox.put('latestList', list);
    return list;
  } catch (e) {
    print(e);
    print("from CsvListController: ERROR!!!!!");
    // return null;
  }
});
