import 'package:flutter/services.dart';
import 'package:flutter_test_application_1/core/ecg_classification.dart';

class LoadCSV{

  static Future<List<int>> loadCSVData() async {
    final String csvData = await rootBundle.loadString('assets/files/iot_1.csv');

    List<int> signals = [];

    List<String> rows = csvData.split('\n');
    if (rows.isNotEmpty) {
      List<String> firstRowColumns = rows.first.split(',');
      if (firstRowColumns.isNotEmpty && int.tryParse(firstRowColumns[0]) != null) {
        for (String row in rows) {
          List<String> columns = row.split(',');
          if (columns.length >= 1) {
            signals.add(int.parse(columns[0]));
          }
        }
      } else {
        for (String row in rows.skip(1)) {
          if (row.isNotEmpty) {
            List<String> columns = row.split(',');
            if (columns.length >= 2) {
              signals.add(int.parse(columns[1]));
            }
          }
        }
      }
    }

    return signals;
  }
}