import 'package:biketheft_berlin/services/csv_download_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final buildListNotificationProvider = StateProvider<String?>((ref) => null);

final csvListProvider = FutureProvider<List<dynamic>?>(
  (ref) async {
    final csvBox = ref.read(csvBoxProvider);
    final csvDownloadService = ref.read(csvDownloadServiceProvider);

    if (csvBox.get('hasChanges') == true) {
      await csvDownloadService.saveCsvToDevice();
      var newList = await csvDownloadService.getLatestCsvList();
      return newList;
    } else {
      return csvBox.get('latestList');
    }
  },
);
