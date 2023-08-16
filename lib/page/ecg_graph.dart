import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test_application_1/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class EcgGraph extends StatefulWidget {
  const EcgGraph({Key? key}) : super(key: key);

  @override
  State<EcgGraph> createState() => _EcgGraphState();
}

class _EcgGraphState extends State<EcgGraph> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    chartData = getChartData();
    Timer.periodic(const Duration(milliseconds: 1), updateDataSource);
    super.initState();
  }

  int time = 19;
  bool isDisposed = false; // Track if dispose has been called
  final int maxDataPoints = 250; // Define the maximum number of data points

  void updateDataSource(Timer timer) {
    print(timer);
    /*chartData.add(LiveData(time++, (math.Random().nextInt(60) + 30)));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
        */      

    if (chartData.length < intArray.length) {
      chartData.add(LiveData(time, (intArray[time]/1000))); // Set the value to 0 or any other value you want to use
      chartData.removeAt(0);
      _chartSeriesController.updateDataSource(
      addedDataIndex: chartData.length - 1, removedDataIndex: 0);
      setState(() {});
      time++;
    } else if (!isDisposed) {
      isDisposed = true;
      dispose();
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Your dispose logic here
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
        appBar: AppBar(title: Text(MyApp.title), centerTitle: true),
        body: SfCartesianChart(
          series: <SplineSeries<LiveData, int>>[
            SplineSeries<LiveData, int>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: chartData,
              color: const Color.fromRGBO(192, 108, 132, 1),
              xValueMapper: (LiveData sales, _) => sales.time,
              yValueMapper: (LiveData sales, _) => sales.speed,
            )
          ],
          primaryXAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.none,
            interval: 10,
            title: AxisTitle(text: 'Time (seconds)'),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum:10,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
            interval: 1,
            title: AxisTitle(text: 'ECG (Mbps)'),
          ),
        )
      )
    );
  }
}

 String jsonData = '''{
    "test": {
      "int": [
        3595,
      2736,
      2258,
      2112,
      1930,
      1978,
      1845,
      1933,
      1806,
      1916,
      1806,
      1923,
      1787,
      1783,
      1632,
      1747,
      1680,
      1813,
      1746,
      1877,
      1851,
      1986,
      1919,
      2028,
      1865,
      1877,
      1744,
      1769,
      1547,
      1614,
      1507,
      1605,
      1651,
      1775,
      1703,
      1826,
      1789,
      1873,
      1773,
      1858,
      1814,
      1885,
      1811,
      1898,
      1815,
      1872,
      1792,
      1865,
      1814,
      1871,
      1783,
      1830,
      1789,
      1871,
      1731,
      1610,
      1589,
      1691,
      1680,
      1783,
      1835,
      1862,
      1808,
      1840,
      1765,
      1813,
      1782,
      1791,
      1774,
      1833,
      1840,
      1710,
      1750,
      2476,
      3554,
      2800,
      2417,
      2093,
      2029,
      2239,
      2674,
      2854,
      2826,
      2832,
      2752,
      2761,
      2854,
      3106,
      3132,
      3121,
      3162,
      3207,
      3120,
      3136,
      3088,
      3078,
      3094,
      3197,
      3163,
      3029,
      3031,
      2966,
      2822,
      2859,
      3218,
      3203,
      3150,
      3200,
      3330,
      3277,
      3360,
      3325,
      3455,
      3332,
      3411,
      3327,
      3502,
      3378,
      3435,
      3312,
      3341,
      3259,
      3299,
      3175,
      3359,
      3163,
      3387,
      3312,
      3452,
      3418,
      3631,
      3724,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      4095,
      3149,
      3569,
      2957
      ]
    }
  }''';

  Map<String, dynamic> parsedJson = json.decode(jsonData);
  List<int> intArray = List<int>.from(parsedJson['test']['int']);

  List<LiveData> getChartData() {

    List<LiveData> chartData = [];

    for(int i=0;i<20;i++){
        chartData.add(LiveData(i, (intArray[i]/1000)));
    }

    return chartData;
    /*
    return <LiveData>[
      LiveData(0, 3445),
      LiveData(1, 1802),
      LiveData(2, 2119),
      LiveData(3, 2858),
      LiveData(4, 3066),
      LiveData(5, 3184),
      LiveData(6, 3227),
      LiveData(7, 3369),
      LiveData(8, 3280),
      LiveData(9, 3097),
      LiveData(10, 2865),
      LiveData(11, 2415),

*/

    
  }




class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}