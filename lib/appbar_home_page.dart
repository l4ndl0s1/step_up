import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:step_up/auth.dart';
import 'package:step_up/get_username.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Auth auth;

  const CustomAppBar({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    Future<void> signOut() async {
      await auth.signOut();
    }

    return AppBar(
      title: Column(
        children: [
          if (user != null)
            GetUserName(
              userUID: user.uid,
              style: const TextStyle(color: Colors.white),
            )
          else
            const Text("User not logged in"),
        ],
      ),
      backgroundColor: const Color(0xff1b2f24),
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                signOut();
              },
              child: const Icon(Icons.logout, color: Colors.white),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
      100); // Adjusted to match the custom height of the AppBar
}
