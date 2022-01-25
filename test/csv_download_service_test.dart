import 'package:biketheft_berlin/controller/csv_download_controller.dart';
import 'package:biketheft_berlin/controller/data_sources_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

// Using mockito to keep track of when a provider notify its listeners
class Listener extends Mock {
  void call(var value);
}

void main() async {
  Hive.init('./test/ressources');
  await Hive.openBox('csvBox');
  group('csvProvider', () {
    // test(
    //   'test csvDownloadServiceProvider w/o mocking; is Hive working? ',
    //   () async {
    //     final container = ProviderContainer();
    //     final service = container.read(csvDownloadServiceProvider);
    //     // final box = container.read(csvBoxProvider);
    //     await service.saveCsvToDevice();
    //     await service.getLatestCsvList();
    //   },
    // );
    test(
      'csv controller',
      () async {
        final container = ProviderContainer();
        expect(
          container.read(csvListProvider),
          const AsyncValue.loading(),
        );

        await container.read(csvListProvider.future);
        //   container.read(csvListProvider).when(
        //       data: (data) => data!.length,
        //       error: (e, _) => print(e),
        //       loading: () => AsyncValue.loading());
        // },
        // );
      },
    );
    test('get accidents string', () async {
      final container = ProviderContainer();
    });
    test('get polygon list', () async {
      final container = ProviderContainer();
      expect(
        container.read(polygonProvider),
        const AsyncValue.loading(),
      );
    });
    // test('download csv as string convert it to list and print it to console',
    //     () async {
    //       csvListProvider.future;
    //   // CsvDownloadService service = CsvDownloadService();
    //   // var data = await service.csvToList();
    //   // print(data);
    // });
    // test('print appDocPath via path_provider', () async {
    //   CsvDownloadService service = CsvDownloadService();
    //   await service.saveCsvToDevice();
    // });
    // test('read latest csv from device and print it', () async {
    //   // final container = ProviderContainer();

    //   // container.listen(csvListControllerProvider);
    //   // print(container.read(csvListControllerProvider).whenData((data) => data));
    //   // .whenData((data) => data!.retainWhere((row) => row.contains(12100102))));
    //   CsvDownloadService service = CsvDownloadService();
    //   var data = await service.getLatestCsvList();

    //   data.retainWhere((row) => row.contains(12100102));
    //   print(data);
  });
}
