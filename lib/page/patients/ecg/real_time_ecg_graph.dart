import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RealTimeEcgGraph extends StatefulWidget {
  const RealTimeEcgGraph({Key? key,required this.patientKey}) : super(key: key);

  final String patientKey;

  @override
  State<RealTimeEcgGraph> createState() => _RealTimeEcgGraphState();
}

class _RealTimeEcgGraphState extends State<RealTimeEcgGraph> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  final DatabaseReference reference =
      FirebaseDatabase.instance.reference().child('Patients').child('ecg');
  late DatabaseReference dbRefPatients;
  late DatabaseReference dbRefRealTimeECG;


  bool isBeginEcg = false; // Added boolean to track whether ECG has started

  @override
  void initState() {
    dbRefPatients = FirebaseDatabase.instance.ref().child('Patients');
    dbRefRealTimeECG = FirebaseDatabase.instance.ref().child('RealTimeECG');

    super.initState();
    chartData = []; 
    // Initialize with empty data
    dbRefPatients.onValue.listen((event) {
      final List<dynamic>? data = event.snapshot.value as List<dynamic>?;
      chartData.clear();
      if (data != null) {
        for (int i = 0; i < data.length; i++) {
          chartData.add(LiveData(i, data[i] / 1000));
        }
        setState(() {});
      }
    });
  }

  
  void startEcg() {
    setState(() {
      isBeginEcg = true;
    });
    updateIsBeginEcg(isBeginEcg); // Update the value in the database
    getRealtimeEcgData();
  }

  void stopEcg() {
    setState(() {
      isBeginEcg = false;
    });
    updateIsBeginEcg(isBeginEcg); // Update the value in the database
  }

void getRealtimeEcgData() async {
  DatabaseReference patientRef = dbRefPatients.child(widget.patientKey);
  DataSnapshot snapshot = await patientRef.get();

  Map<dynamic, dynamic>? patient = snapshot.value as Map<dynamic, dynamic>?;

  if (patient != null && patient.containsKey('ecg')) {
    List<dynamic>? ecgData = patient['ecg'];

    if (ecgData != null && ecgData.isNotEmpty) {
      List<dynamic> lastEcgRecord = ecgData.last['value'];

      if (lastEcgRecord != null && lastEcgRecord.isNotEmpty) {
        chartData.clear();

        for (int i = 0; i < lastEcgRecord.length; i++) {
          chartData.add(LiveData(i, lastEcgRecord[i] / 1000));
        }

        setState(() {});
      } else {
        _showNoDataDialog();
      }
    } else {
      _showNoDataDialog();
    }
  } else {
    _showNoDataDialog();
  }
}

void updateIsBeginEcg(bool value) {
  DatabaseReference realTimeEcgRef = dbRefRealTimeECG;
  
  // Update the isBeginEcg value in the database
  realTimeEcgRef.update({
    'patient_key':widget.patientKey,
    'isBeginEcg': value,
  }).then((_) {
    print('isBeginEcg updated successfully.');
  }).catchError((error) {
    print('Failed to update isBeginEcg: $error');
  });
}

void _showNoDataDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('No ECG Data'),
        content: Text('There is no ECG data available for this patient.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('ECG Graph'), centerTitle: true),
         body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center buttons horizontally
              children: [              
                ElevatedButton(
                  onPressed: startEcg,
                  child: Text('Start'),
                ),
                SizedBox(
                  width:15,
                ),
                ElevatedButton(
                  onPressed: stopEcg,
                  child: Text('Stop'),
                ),
              ],
            

            ),
            
            Expanded(
              child: SfCartesianChart(
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
          ],
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
