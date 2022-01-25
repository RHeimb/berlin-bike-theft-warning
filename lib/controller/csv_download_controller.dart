import 'dart:io';

import 'package:biketheft_berlin/general_provider.dart';
import 'package:biketheft_berlin/services/csv_download_service.dart';
import 'package:biketheft_berlin/services/csv_read_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

final buildListNotificationProvider = StateProvider<String?>((ref) => null);

final defaultCsvReaderProvider = FutureProvider<String?>((ref) async {
  final csvString = await ref
      .read(csvReadServiceProvider)
      .readCsv(path: 'assets/thefts_default.csv');
  return csvString;
});

final csvListProvider = FutureProvider<List<dynamic>?>(
  (ref) async {
    final csvBox = ref.read(csvBoxProvider);
    final csvDownloadService = ref.read(csvDownloadServiceProvider);
    final networkConnect = ref.read(networkConnectionAvailable);
    try {
      await csvDownloadService.getCsv();
    } on SocketException catch (e) {
      print(e.toString());
      networkConnect.state = false;
      final defaultCsv = await ref.read(defaultCsvReaderProvider.future);
      await csvDownloadService.getDefaultCsvList(defaultCsv: defaultCsv!);
    } on ClientException catch (e) {
      print(e.toString());
    }
    final hasChanges = await csvBox.get('hasChanges');
    if (hasChanges == true) {
      var newList = await csvDownloadService.getLatestCsvList();
      return newList;
    } else {
      return csvBox.get('latestList');
    }
  },
);
