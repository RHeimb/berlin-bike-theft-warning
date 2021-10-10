import 'package:bikedata_berlin/services/csv_download_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Using mockito to keep track of when a provider notify its listeners
class Listener extends Mock {
  void call(var value);
}

void main() {
  test('download csv as string convert it to list and print it to console', () async {
    CsvDownloadService service = CsvDownloadService();
    var data = await service.csvToList();
    print(data);
  });
  test('print appDocPath via path_provider', () async {
    CsvDownloadService service = CsvDownloadService();
    await service.saveCsvToDevice();
  });
  test('read latest csv from device and print it', () async {
    // final container = ProviderContainer();

    // container.listen(csvListControllerProvider);
    // print(container.read(csvListControllerProvider).whenData((data) => data));
    // .whenData((data) => data!.retainWhere((row) => row.contains(12100102))));
    CsvDownloadService service = CsvDownloadService();
    var data = await service.getLatestCsvList();

    data.retainWhere((row) => row.contains(12100102));
    print(data);
  });
}
