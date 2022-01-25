import 'dart:io';

import 'package:csv/csv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// Stream provider which hold update status of csv -> watched from MapScreen to show snackbar
// final csvStatusProvider = StreamProvider.autoDispose<bool>((ref) async* {
//  yield ref.read(csvDownloadServiceProvider).updating;
final csvStatusProvider = StateProvider((ref) => true);

final csvBoxProvider = Provider<Box<dynamic>>((ref) {
  var csvBox = Hive.box('csvBox');
  // print(csvBox.get('lastModified').toString());
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

  Future<void> getCsv() async {
    var _lastModified;
    try {
      _lastModified = HttpDate.parse(_csvBox.get('lastModified'));
    } catch (e) {
      _lastModified = _csvBox.get('lastModified');
    }

    var url = Uri.parse(
        'https://www.internetwache-polizei-berlin.de/vdb/Fahrraddiebstahl.csv');
    var response = await http.get(url);
    var lm = HttpDate.parse(response.headers['last-modified']!);
    if (response.statusCode == 200) {
      if (_lastModified != null) {
        if (lm.difference(_lastModified).inDays < 6) {
          await _csvBox.put('hasChanges', false);
        } else {
          await _csvBox.put('lastModified', lm);
          await _csvBox.put('hasChanges', true);
          await _csvBox.put('lastCsv', response.body);
        }
      } else {
        await _csvBox.put('lastModified', lm);
        await _csvBox.put('hasChanges', true);
        await _csvBox.put('lastCsv', response.body);
      }
    }
  }

  Future<List<List<dynamic>>> csvToList() async {
    final csv = await _csvBox.get('lastCsv');
    final rowsAsListOfValues = const CsvToListConverter().convert(csv);
    return rowsAsListOfValues;
  }

  Future<void> saveCsvToDevice() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    final String appDocPath = appDocDir.path;
    final String finalAppDocPath =
        "$appDocPath\\csv-${DateFormat.MMMM().format(DateTime.now())}.csv";
    final csv = await _csvBox.get('lastCsv');
    final File file = File(finalAppDocPath);
    await file.writeAsString(csv!);
  }

  Future<List<List<dynamic>>> getLatestCsvList() async {
    // String currentMonth = DateFormat.MMMM().format(DateTime.now());
    // Directory appDocDir = await getApplicationSupportDirectory();
    // final String appDocPath = appDocDir.path;
    // final String path = "$appDocPath\\csv-$currentMonth.csv";

    // final String file =
    //     await File(path).readAsString().then((String content) => content);
    final String csv = await _csvBox.get('lastCsv');
    final rowsAsListOfValues = const CsvToListConverter().convert(csv);
    await _csvBox.put('latestList', rowsAsListOfValues);
    return rowsAsListOfValues;
  }

  Future<List<List<dynamic>>> getDefaultCsvList(
      {required String defaultCsv}) async {
    await _csvBox.put('hasChanges', false);
    final rowsAsListOfValues = const CsvToListConverter().convert(defaultCsv);
    await _csvBox.put('latestList', rowsAsListOfValues);
    return rowsAsListOfValues;
  }
}
