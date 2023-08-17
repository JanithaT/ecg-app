import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_application_1/page/patients/ecg/real_time_ecg_graph.dart';
import 'package:flutter_test_application_1/page/my_home_page.dart.dart';
import 'package:flutter_test_application_1/page/patients/fetch_patient_data.dart';
import 'package:flutter_test_application_1/page/patients/insert_patient_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    static final String title = 'ECG';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ÉCG',),
    );

/*
    return   MaterialApp(
       home:Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Image(
              width: 300,
              height: 300,
              image: NetworkImage(
                  'https://seeklogo.com/images/F/firebase-logo-402F407EE0-seeklogo.com.png'),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Firebase Realtime Database Series in Flutter 2022',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InsertPatientData()));
              },
              child: const Text('Insert Data'),
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FetchPatientData()));
              },
              child: const Text('Fetch Data'),
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
             
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EcgGraph()));
              },
              child: const Text('RealTime ECG Data'),
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
            
            ],
          ),
        ),
      ),
    );
    */

  }
}
 


