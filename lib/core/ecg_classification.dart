import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class EcgClassification extends StatefulWidget {
  const EcgClassification({super.key, required this.signals});

  final List<int> signals;
  @override
  _EcgClassificationState createState() => _EcgClassificationState();
}

class _EcgClassificationState extends State<EcgClassification> {
  List<double> denoisedSignals = [];
  List<double> zScores = [];
  List<PieChartSectionData> pieChartData = [];
  int windowSize = 180; 
  List<List<double>> reshapedZScores = [];
  late Interpreter _interpreter;
  List<String> _labels = [];


  @override
  void initState() {
    super.initState();
    preProcessingData();
    loadTFLiteModel();
  }

/*
  Future<void> loadCSVData() async {
    final String csvData = await rootBundle.loadString('assets/files/iot_1.csv');

    List<String> rows = csvData.split('\n');
    if (rows.isNotEmpty) {
      List<String> firstRowColumns = rows.first.split(',');
      if (firstRowColumns.isNotEmpty && int.tryParse(firstRowColumns[0]) != null) {
        for (String row in rows) {
            List<String> columns = row.split(',');
            if (columns.length >= 1) {
              widget.signals.add(int.parse(columns[0]));
            }
        }
      } else {
        for (String row in rows.skip(1)) {
          if (row.isNotEmpty) {
            List<String> columns = row.split(',');
            if (columns.length >= 2) {
              widget.signals.add(int.parse(columns[1]));
            }
          }
        }
      }
    }

      print(signals.length);

  }
  */

  Future<void> preProcessingData() async {
    List<double> doubleSignals = widget.signals.map((value) => value.toDouble()).toList();
    denoisedSignals = denoise(doubleSignals,5);

    zScores = calculateZScores(denoisedSignals);
    
    reshapedZScores = reshapeZScores(zScores, zScores.length, 360);

    setState(() {});
      
    print(widget.signals.length);
    print(reshapedZScores.length);
    print(reshapedZScores[0].length);
    print(reshapedZScores);
    }
  

    List<List<double>> reshapeData(List<double> data, int sequenceLength) {
    int numSamples = data.length;

    List<List<double>> reshapedData = [];

    for (int i = 0; i < numSamples - sequenceLength + 1; i++) {
      List<double> sampleSequence = data.sublist(i, i + sequenceLength);
      reshapedData.add(sampleSequence);
    }
    return reshapedData;
  }

  List<double> denoise(List<double> data, int windowSize) {
  List<double> denoisedData = [];

  for (int i = 0; i < data.length; i++) {
    int startIndex = i - windowSize ~/ 2;
    int endIndex = i + windowSize ~/ 2;

    if (startIndex < 0) {
      startIndex = 0;
    }
    if (endIndex >= data.length) {
      endIndex = data.length - 1;
    }

    double sum = 0;
    int count = 0;
    for (int j = startIndex; j <= endIndex; j++) {
      sum += data[j];
      count++;
    }

    double average = sum / count;
    denoisedData.add(average);
  }

  return denoisedData;
}


  List<double> calculateZScores(List<double> data) {
    double sum = 0;
    for (var value in data) {
      sum += value;
    }
    double mean = sum / data.length;

    double sumOfSquaredDifferences = 0;
    for (var value in data) {
      double difference = value - mean;
      sumOfSquaredDifferences += difference * difference;
    }
    double standardDeviation = sqrt(sumOfSquaredDifferences / (data.length - 1));

    List<double> zScores = [];
    for (var value in data) {
      double zScore = (value - mean) / standardDeviation;
      zScores.add(zScore);
    }

    return zScores;
  }

 List<List<double>> reshapeZScores(List<double> zScores, int numRows, int numColumns) {
  List<List<double>> reshapedData = [];

  int currentIndex = 0;
  for (int i = 0; i < numRows; i++) {
    List<double> row = [];
    for (int j = 0; j < numColumns; j++) {
      if (currentIndex < zScores.length) {
        row.add(zScores[currentIndex]);
        currentIndex++;
      } else {
        row.add(0.0);
      }
    }
    reshapedData.add(row);
  }

  return reshapedData;
}

Future<void> loadTFLiteModel() async {
  String modelPath = 'assets/transformer_model.tflite';
  _interpreter = await Interpreter.fromAsset(modelPath);

  String labels = await rootBundle.loadString('assets/label.txt');
  _labels = labels.split('\n');
}


Future<void> predictAndDisplayPieChart() async {
  List<List<double>> inputData = reshapedZScores;
  List<List<double>> outputData = [];

  for (var input in inputData) {
    var inputTensor = Float32List.fromList(input.expand((value) => [value]).toList());
    var outputTensor = Float32List(1 * _labels.length);
    _interpreter.run(inputTensor.buffer, outputTensor.buffer);

    var reshapedOutput = List.generate(1, (i) {
      var start = i * _labels.length;
      var end = start + _labels.length;
      return outputTensor.sublist(start, end);
    });

    outputData.addAll(reshapedOutput);
  }

  List<int> predictions = [];
  for (var output in outputData) {
    int prediction = output.indexOf(output.reduce((max)));
    predictions.add(prediction);
  }

  Map<int, int> classCounts = Map();
    for (var prediction in predictions) {
     classCounts[prediction] = (classCounts[prediction] ?? 0) + 1;
  }

  print(predictions);

    // Create pie chart data
    List<PieChartSectionData> pieChartData = [];

      List<Color> predefinedColors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
    ];

    classCounts.forEach((classIndex, count) {
      pieChartData.add(PieChartSectionData(
        value: count.toDouble(),
        title: '${_labels[classIndex]}: $count',
        color: predefinedColors[classIndex % predefinedColors.length],
      ));
    });

    setState(() {
      this.pieChartData = pieChartData;
    });
  }



  @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('CSV Processing')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: predictAndDisplayPieChart,
                child: Text('Process Classification and Display Pie Chart'),
              ),
              SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.5,
                child: PieChart(
                  PieChartData(
                    sections: pieChartData,
                  ),
                ),
              ),
              if (pieChartData.isNotEmpty)
                PieChart(
                  PieChartData(
                    sections: pieChartData,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
}