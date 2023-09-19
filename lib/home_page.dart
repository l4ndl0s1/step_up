import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:step_up/step_counter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle30 = TextStyle(fontSize: 30);
    const textStyle20 = TextStyle(fontSize: 20);

    return Consumer<PedometerProvider>(
      builder: (context, pedometerProvider, child) {
        // You might add more specific error handling here, depending on the implementation of PedometerProvider

        return Scaffold(
          backgroundColor: Colors.grey[300],
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo_1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Text('Daily distance:', style: textStyle30),
                  Text('${pedometerProvider.steps} Steps', style: textStyle30),
                  Text(
                    '${pedometerProvider.distanceInKm.toStringAsFixed(2)} km',
                    style: textStyle30,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Time until reset: ${pedometerProvider.timeUntilReset}',
                    style: textStyle20,
                  ),
                  Center(
                    child: Text(
                      pedometerProvider.status,
                      style: pedometerProvider.status == 'walking' ||
                              pedometerProvider.status == 'stopped'
                          ? textStyle30
                          : textStyle20.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
