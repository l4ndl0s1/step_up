import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_up/auth.dart';
import 'package:step_up/step_counter.dart'; // You also need to import the provider package

class OptionsPage extends StatelessWidget {
  OptionsPage({Key? key}) : super(key: key); // Corrected the key parameter
  final auth = Auth();

  Future<void> signOut() async {
    await auth.signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Options Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text('Reset all my steps form the Day.'),
          ElevatedButton(
            onPressed: () {
              Provider.of<PedometerProvider>(context, listen: false)
                  .resetSteps();
            },
            child: const Text('Reset'),
          ),
          _signOutButton(),
        ],
      ),
    );
  }
}
