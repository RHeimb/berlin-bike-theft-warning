import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final csvReadServiceProvider =
    Provider<CsvReadService>((ref) => CsvReadService());

class CsvReadService {
  const CsvReadService();

  Future<String?> readCsv({required String path}) async {
    return await rootBundle.loadString(path).then((csv) => csv);
  }
}
