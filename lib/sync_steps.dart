import 'package:firebase_core/firebase_core.dart'; // Add this import to access Firebase.app()
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SynySteps extends StatefulWidget {
  const SynySteps({super.key});

  @override
  State<SynySteps> createState() => _SynyStepsState();
}

class _SynyStepsState extends State<SynySteps> {
  String _realTimeValue = "0";

  @override
  Widget build(BuildContext context) {
    final firebaseApp = Firebase.app();
    DatabaseReference stepRef = FirebaseDatabase.instanceFor(
            app: firebaseApp,
            databaseURL:
                'https://stepup-70394-default-rtdb.europe-west1.firebasedatabase.app/')
        .ref()
        .child('count');

    stepRef.onValue.listen((event) {
      setState(() {
        _realTimeValue = event.snapshot.value.toString();
      });
    });

    return Column(
      children: [
        Text(_realTimeValue),
        ElevatedButton(
          onPressed: () {
            // Setting the value in the database to 100
            stepRef.set(11100).then((_) {
              print("Value successfully updated to 100 in Firebase");
            }).catchError((error) {
              print("Failed to update value to Firebase: $error");
            });
          },
          child: const Text('Update Count to 100'),
        ),
      ],
    );
  }
}
