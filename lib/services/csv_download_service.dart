import 'dart:io';

import 'package:csv/csv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

final csvDownloadServiceProvider = Provider<CsvDownloadService>((ref) {
  return CsvDownloadService();
});

class CsvDownloadService {
  const CsvDownloadService();

  Future<String?> getCsv() async {
    var url =
        Uri.parse('https://www.internetwache-polizei-berlin.de/vdb/Fahrraddiebstahl.csv');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future<List<List<dynamic>>> csvToList() async {
    final csv = await getCsv();
    final rowsAsListOfValues = const CsvToListConverter().convert(csv);
    return rowsAsListOfValues;
  }

  Future<void> saveCsvToDevice() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    final String appDocPath = appDocDir.path;
    final String finalAppDocPath =
        "$appDocPath\\csv-${DateFormat.MMMM().format(DateTime.now())}.csv";
    final csv = await getCsv();
    final File file = File(finalAppDocPath);
    await file.writeAsString(csv!);
  }

  Future<List<List<dynamic>>> getLatestCsvList() async {
    // var csvBox = Hive.box('csvBox');
    String currentMonth = DateFormat.MMMM().format(DateTime.now());
    Directory appDocDir = await getApplicationSupportDirectory();
    final String appDocPath = appDocDir.path;
    final String path = "$appDocPath\\csv-$currentMonth.csv";
    print(path);

    final String file = await File(path).readAsString().then((String content) => content);
    final rowsAsListOfValues = const CsvToListConverter().convert(file);
    // await csvBox.put('latestList', rowsAsListOfValues);
    return rowsAsListOfValues;
  }
}
