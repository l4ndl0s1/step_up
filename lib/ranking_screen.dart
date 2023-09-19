import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:step_up/get_username.dart';
import 'package:firebase_database/firebase_database.dart'; // Import firebase_database

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> docIDs = [];

  Future<void> getDocIDs() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

  Future<String> getRealTimeValue(String userUID) async {
    final firebaseApp = Firebase.app();
    DatabaseReference stepRef = FirebaseDatabase.instanceFor(
            app: firebaseApp,
            databaseURL:
                'https://stepup-70394-default-rtdb.europe-west1.firebasedatabase.app/')
        .ref()
        .child('count');

    String realTimeValue = "Fetching...";

    try {
      DataSnapshot snapshot = await stepRef.get();
      realTimeValue = snapshot.value?.toString() ?? "No data";
    } catch (e) {
      realTimeValue = "Error fetching data";
    }

    return realTimeValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getDocIDs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: docIDs.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<String>(
                          future: getRealTimeValue(docIDs[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ListTile(
                                title: GetUserName(userUID: docIDs[index]),
                                subtitle:
                                    Text('Steps of the day: ${snapshot.data}'),
                              );
                            } else {
                              return ListTile(
                                title: GetUserName(userUID: docIDs[index]),
                                subtitle:
                                    const Text('Fetching real time value...'),
                              );
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Loading...',
                          style: TextStyle(color: Colors.black, fontSize: 10),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 150),
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            backgroundColor: Color.fromARGB(255, 9, 66, 10),
                            valueColor: AlwaysStoppedAnimation(
                                Color.fromARGB(255, 0, 0, 0)),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
