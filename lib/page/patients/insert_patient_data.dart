import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
 
class InsertPatientData extends StatefulWidget {
  const InsertPatientData({Key? key}) : super(key: key);
 
  @override
  State<InsertPatientData> createState() => _InsertPatientDataState();
}
 
class _InsertPatientDataState extends State<InsertPatientData> {
  
  final  patientNameController = TextEditingController();
  final  patientAgeController= TextEditingController();
  final  patientMobileController =TextEditingController();
 
  late DatabaseReference dbRef;
 
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Students');
  }
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Patient'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Adding Patient\'s Data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: patientNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter Patient Name',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: patientAgeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age',
                  hintText: 'Enter Patient Age',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: patientMobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mobile No',
                  hintText: 'Enter Patient Mobile No',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  Map<String, String> students = {
                    'name': patientNameController.text,
                    'age': patientAgeController.text,
                    'mobile': patientMobileController.text
                  };
 
                  dbRef.push().set(students);
 
                },
                child: const Text('Add Patient'),
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
  }
}