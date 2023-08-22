import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_application_1/core/ecg_plot/ecg_plot.dart';
import 'package:flutter_test_application_1/core/ecg_plot/feature_plot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../core/full_ecg_data.dart';

class RealTimePrediction extends StatefulWidget {
  const RealTimePrediction({Key? key,required this.patientKey, required this.allIncomingEcgData}) : super(key: key);

  final String patientKey;
  final List<FullEcgData> allIncomingEcgData;

  @override
  State<RealTimePrediction> createState() => _RealTimePredictionState();
}

class _RealTimePredictionState extends State<RealTimePrediction> {
    late final List<double> signals;

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
  Future<void> preProcessingData() async {
     List<double> speedSignals = widget.allIncomingEcgData.map((data) => data.speed).toList();
    setState(() {
      signals = speedSignals; // Store the speed data in the 'signals' list
    });

    //List<double> doubleSignals = signals.map((value) => value.toDouble()).toList();
    denoisedSignals = denoise(speedSignals,10);

    zScores = calculateZScores(denoisedSignals);
    
    reshapedZScores = reshapeZScores(zScores,  360);


    setState(() {});
    print("********** signals ************");
    print(signals.length);  

    print("********** Reshaped row ************");
    print(reshapedZScores.length);
    
    print("********** reshaped zscore column ************");        
    print(reshapedZScores[0].length);


   
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

 List<List<double>> reshapeZScores(List<double> zScores, int windowSize) {
  List<List<double>> reshapedData = [];
  double threshold = 3.0; // You can adjust this threshold as needed

  List<int> highPointIndices = [];
  for (int i = 1; i < zScores.length - 1; i++) {
    if (zScores[i] > threshold &&
        zScores[i] > zScores[i - 1] &&
        zScores[i] > zScores[i + 1]) {
      highPointIndices.add(i);
    }
  }

    print("**********R peak count************");
    print(highPointIndices.length);

  for (int highIndex in highPointIndices) {
    int startIndex = highIndex - windowSize ~/ 2;
    int endIndex = highIndex + windowSize ~/ 2 - 1; // Adjust for 360 points

    if (startIndex < 0) {
      endIndex += -startIndex; // Adjust endIndex for edge case
      startIndex = 0;
    }
    if (endIndex >= zScores.length) {
      startIndex -= endIndex - (zScores.length - 1); // Adjust startIndex for edge case
      endIndex = zScores.length - 1;
    }

    List<double> rowData = [];
    for (int j = startIndex; j <= endIndex; j++) {
      rowData.add(zScores[j]);
    }

    reshapedData.add(rowData);
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
      Colors.red,
      Colors.green,
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


              Text('Real ECG Graph'),              
              SizedBox(height: 5),                    
              EcgPlot(signals: signals, min:0,max:4500),

              Text('ECG Graph after Deniosed'),              
              SizedBox(height: 5),             
              EcgPlot(signals: denoisedSignals, min:0,max:4500),

              Text('ECG Graph Z score normalization'),              
              SizedBox(height: 5),             
              EcgPlot(signals: zScores, min:-2,max:6),

              Text('Fearure Extraction'),              
              SizedBox(height: 5),             
              FeaturePlot(reshapedData: reshapedZScores, min:-2,max:6),

              SizedBox(height: 20),

              // PieChart displaying classification results
              AspectRatio(
                aspectRatio: 3.0,
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





class ChartSampleData {
  final double x;
  final double y;

  ChartSampleData({required this.x, required this.y});
}