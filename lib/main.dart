import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_up/app_settings.dart';
import 'package:step_up/widget_tree.dart';

import 'step_counter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(); // Firebase initialization
  } catch (error) {
    // Handle the error appropriately - maybe report to an error tracking service
    if (kDebugMode) {
      print("Firebase initialization error: $error");
    }
    return; // Prevent the app from continuing to run
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PedometerProvider()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        // Add other providers here if you have any
      ],
      child: const StepUp(),
    ),
  );
}

class StepUp extends StatelessWidget {
  const StepUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      home: const WidgetTree(),
      // Add routes here if you have any
    );
  }
}
