import 'package:flutter/material.dart';
import 'package:step_up/login_page.dart';
import 'package:step_up/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
          showRegisterPage: toggleScreen); // This line should now work
    } else {
      return RegisterPage(showLoginPage: toggleScreen);
    }
  }
}
