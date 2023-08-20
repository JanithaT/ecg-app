import 'dart:ffi';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RealTimeEcgScreen extends StatefulWidget {
  const RealTimeEcgScreen({Key? key,required this.patientKey, required this.ecgIndex}) : super(key: key);

  final String patientKey;
  final int ecgIndex;

  @override
  _RealTimeEcgScreenState createState() => _RealTimeEcgScreenState();
}

class _RealTimeEcgScreenState extends State<RealTimeEcgScreen> {
  final DatabaseReference _iotConnectRef =
      FirebaseDatabase.instance.reference().child('RealTimeECG');
  List<double> ecgData = [];
  bool iotConnected = false;
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
   late DatabaseReference dbRefPatients;
  late DatabaseReference dbRefRealTimeECG;


  String isBeginEcg = "false"; 
  int lastEcgIndex =0;
  bool iotConnect=false;
List<dynamic> ecgRecords = []; // Store fetched records here

  @override
  void initState() {
    super.initState();
    _iotConnectRef.onValue.listen((event) {
      setState(() {
        iotConnected = event.snapshot.value == true;
      });
    });

    // Simulate incoming ECG data
    _simulateECGData();
  }
Future<void> _simulateECGData() async {
  final DatabaseReference dbRefEcgIndex = FirebaseDatabase.instance.ref().child('Patients').child(widget.patientKey).child('ecg');
  DataSnapshot snapshot = await dbRefEcgIndex.get();
  Map<dynamic, dynamic>? ecgRecords = snapshot.value as Map<dynamic, dynamic>?;
  List<dynamic>? ecgValue = ecgRecords?[widget.ecgIndex.toString()];
  //double ecgPoint = ecgValue?[i] as double; // Cast to double

  // Simulate adding new ECG data points
  Future.delayed(Duration(seconds: 1), () {
    if (iotConnected) {
      setState(() {
        
       // ecgData.addAll(ecgValue);
        if (chartData.length > 10) {
          chartData.removeAt(0);
        }
/*
        for (int i = 0; i < ecgValue.length; i++) {
           chartData.add(LiveData(i * 3, ecgValue[i] / 1000)); // Adjust this line according to your data structure
  if (chartData.length > 10) {
    chartData.removeAt(0);
  }*/
        }
      );

      _simulateECGData();
    }
  });
}


  
  
  void startEcg() {
    setState(() {
      isBeginEcg = "true";
    });
    updateIsBeginEcg(isBeginEcg); // Update the value in the database
    _simulateECGData();
  }

  bool getIoTConnect(){
    dbRefRealTimeECG = FirebaseDatabase.instance.ref().child('RealTimeECG').child('iotConnect');

    return true;
  }

  void stopEcg() {
    setState(() {
      isBeginEcg = "false";
    });
    //updateIsBeginEcg(isBeginEcg); // Update the value in the database
  }

  

void updateIsBeginEcg(String value) {
  DatabaseReference realTimeEcgRef = dbRefRealTimeECG;
  DateTime currentDateTime = DateTime.now();

  // Update the isBeginEcg value in the database
  realTimeEcgRef.update({
    'patient_key':widget.patientKey,
    'isBeginEcg': value,
    'ecgIndex':widget.ecgIndex,
    'dateTime':currentDateTime.toString(),
  }).then((_) {
    print('isBeginEcg updated successfully.');
  }).catchError((error) {
    print('Failed to update isBeginEcg: $error');
  });
}


 

  double _generateRandomECGValue() {
    return (50 + (10 * (1 - 2 * (0.5 - Random().nextDouble()))));
  }

  @override
  Widget build(BuildContext context) {
     return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('ECG Graph'), centerTitle: true),
        body: SfCartesianChart(
          series: <SplineSeries<LiveData, int>>[
            SplineSeries<LiveData, int>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: chartData,
              color: const Color.fromRGBO(192, 108, 132, 1),
              xValueMapper: (LiveData data, _) => data.time,
              yValueMapper: (LiveData data, _) => data.speed,
            )
          ],
          primaryXAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.none,
            interval: 10,
            title: AxisTitle(text: 'Time (Milli Seconds)'),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 4,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
            interval: 1,
            title: AxisTitle(text: 'ECG (Mbps)'),
          ),
        ),
      ),
    );
  }
}


class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final double speed;
}