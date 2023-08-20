import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RealTimeEcgGraph extends StatefulWidget {
  const RealTimeEcgGraph({Key? key,required this.patientKey, required this.ecgIndex}) : super(key: key);

  final String patientKey;
  final int ecgIndex;



  @override
  State<RealTimeEcgGraph> createState() => _RealTimeEcgGraphState();
}

class _RealTimeEcgGraphState extends State<RealTimeEcgGraph> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  late DatabaseReference dbRefPatients;
  late DatabaseReference dbRefRealTimeECG;
  late DatabaseReference dbRefPatientsECG;

  String isBeginEcg = "false"; 
  int lastEcgIndex =0;
  bool iotConnect=false;


  @override
  void initState() {
    dbRefPatients = FirebaseDatabase.instance.ref().child('Patients').child(widget.patientKey);
    dbRefRealTimeECG = FirebaseDatabase.instance.ref().child('RealTimeECG');

    super.initState();

   dbRefRealTimeECG.onValue.listen((event) {
  final Map<dynamic, dynamic>? snapshotValue = event.snapshot.value as Map<dynamic, dynamic>?;
  if (snapshotValue != null) {
    setState(() {
      iotConnect = snapshotValue['isBeginEcg'] == 'true';
    });
  }
});







    chartData = [];
    getRealtimeEcgData();
dbRefPatients.onValue.listen((event) {
      final dynamic data = event.snapshot.value;
      chartData.clear();
      if (data != null && iotConnect) {
        final List<dynamic>? ecgList = data['ecg'] as List<dynamic>?; // Use the conditional type check
        if (ecgList != null) {
          for (int i = 0; i < ecgList.length; i++) {
            final Map<dynamic, dynamic>? ecgEntry = ecgList[widget.ecgIndex] as Map<dynamic, dynamic>?; // Use the conditional type check
            if (ecgEntry != null && ecgEntry.containsKey('value')) {
              final List<dynamic> ecgValues = ecgEntry['value'];
              for (int j = 0; j < ecgValues.length; j++) {
                chartData.add(LiveData(i * ecgValues.length + j, ecgValues[j] / 1000));
                if (chartData.length > 1029) {
                  chartData.removeAt(0);
                }
              }
            }
          }
          setState(() {});
        }
      }
    });
  }

  // ... (rest of the class


  
  void startEcg() {
    setState(() {
      isBeginEcg = "true";
    });
    updateIsBeginEcg(isBeginEcg); // Update the value in the database
    getRealtimeEcgData();
  }

  bool getIoTConnect(){
    dbRefRealTimeECG = FirebaseDatabase.instance.ref().child('RealTimeECG').child('iotConnect');
    return false;
  }

  void stopEcg() {
    setState(() {
      isBeginEcg = "false";
    });
    updateIsBeginEcg(isBeginEcg); // Update the value in the database
  }
Future<void> getRealtimeEcgData() async {
    dbRefPatientsECG= FirebaseDatabase.instance.ref().child('Patients').child(widget.patientKey).child('ecg').child(widget.ecgIndex.toString());
    

     dbRefPatientsECG.onChildAdded.listen((event) {
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null && snapshot.value is Map) {
      Map<dynamic, dynamic> ecgData = snapshot.value as Map<dynamic, dynamic>;
      int time = ecgData['time'];
      print("***********************"+time.toString()+"***************");
      double speed = ecgData['speed'];

      setState(() {
        chartData.add(LiveData(time, speed));
      });
    }
  });

  dbRefPatientsECG.onChildRemoved.listen((event) {
    setState(() {
      chartData.clear();
    });
  });
}




void updateIsBeginEcg(String value) {
  DatabaseReference realTimeEcgRef = dbRefRealTimeECG;
  print(DateFormat.yMMMd().format(DateTime.now()));

   //currentDateTime = DateFormat.yMMMd().format(DateTime.now());

  // Update the isBeginEcg value in the database
  realTimeEcgRef.update({
    'patient_key':widget.patientKey,
    'isBeginEcg': value,
    'ecgIndex':widget.ecgIndex,
    'dateTime':DateFormat.yMd().add_jm().format(DateTime.now()).toString(),
  }).then((_) {
    print('isBeginEcg updated successfully.');
  }).catchError((error) {
    print('Failed to update isBeginEcg: $error');
  });
  getRealtimeEcgData();
}

void _showNoDataDialog(String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('No ECG Data'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
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
            interval: 100,
            title: AxisTitle(text: 'Time (Milli Seconds)'),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 4.5,
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
