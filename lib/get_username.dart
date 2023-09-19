import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatefulWidget {
  final String userUID;
  final TextStyle? style;
  const GetUserName({required this.userUID, this.style, Key? key})
      : super(key: key);

  @override
  GetUserNameState createState() => GetUserNameState();
}

class GetUserNameState extends State<GetUserName> {
  Future<Map<String, dynamic>>? userData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userUID)
        .get();
    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: widget.style);
        } else if (snapshot.hasData) {
          return Text('${snapshot.data!['user name']}', style: widget.style);
        } else {
          return Text('Unknown user', style: widget.style);
        }
      },
    );
  }
}
