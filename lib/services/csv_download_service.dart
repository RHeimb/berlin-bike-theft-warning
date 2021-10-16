import 'dart:io';

import 'package:csv/csv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

final csvBoxProvider = Provider<Box<dynamic>>((ref) {
  var csvBox = Hive.box('csvBox');
  print(csvBox.get('lastModified').toString());
  ref.onDispose(() async {
    await csvBox.compact();
    await csvBox.close();
  });
  return csvBox;
});

final csvDownloadServiceProvider = Provider<CsvDownloadService>((ref) {
  final Box csvBox = ref.read(csvBoxProvider);
  if (csvBox.get('lastModified') == null) {
    csvBox.put('hasChanges', true);
  }

  return CsvDownloadService(ref.read, csvBox);
});

class CsvDownloadService {
  CsvDownloadService(this._read, this._csvBox);
  final Reader _read;
  final Box _csvBox;

  Future<String?> getCsv() async {
    final _lastModified = _csvBox.get('lastModified');
    var url = Uri.parse(
        'https://www.internetwache-polizei-berlin.de/vdb/Fahrraddiebstahl.csv');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (_lastModified != null) {
        await _csvBox.put('lastModified', response.headers['last-modified']);
        if (_lastModified == response.headers['last-modified']) {
          await _csvBox.put('hasChanges', false);
          return response.body;
        } else {
          await _csvBox.put('lastModified', response.headers['last-modified']);
          return response.body;
        }
      } else {
        await _csvBox.put('lastModified', response.headers['last-modified']);
        return response.body;
      }
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
    String currentMonth = DateFormat.MMMM().format(DateTime.now());
    Directory appDocDir = await getApplicationSupportDirectory();
    final String appDocPath = appDocDir.path;
    final String path = "$appDocPath\\csv-$currentMonth.csv";
    print(path);

    final String file =
        await File(path).readAsString().then((String content) => content);
    final rowsAsListOfValues = const CsvToListConverter().convert(file);
    await _csvBox.put('latestList', rowsAsListOfValues);
    return rowsAsListOfValues;
  }
}
