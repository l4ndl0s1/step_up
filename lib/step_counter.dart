import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class PedometerProvider extends ChangeNotifier {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  String _steps = '?';
  int _initialSteps = 0;
  bool _isInitialStepCountSet = false;
  late Timer _resetTimer;
  String _timeUntilReset = '24:00:00';
  late Timer _secondTimer;
  double _distanceInKm = 0.0;
  static const double stepLength = 0.78 / 2; // meters per step

  PedometerProvider() {
    initPlatformState();
    _startResetTimer();
    _startSecondTimer();
  }

  String get status => _status;
  String get steps => _steps;
  String get timeUntilReset => _timeUntilReset;
  double get distanceInKm => _distanceInKm;

  void onStepCount(StepCount event) {
    if (!_isInitialStepCountSet) {
      _initialSteps = event.steps;
      _isInitialStepCountSet = true;
    }
    int stepsTaken = event.steps - _initialSteps;
    _steps = stepsTaken.toString();
    _distanceInKm = (stepsTaken * stepLength) / 1000; // convert to kilometers

    // Get the Firebase app and create a reference to the database
    final firebaseApp = Firebase.app();
    DatabaseReference stepRef = FirebaseDatabase.instanceFor(
            app: firebaseApp,
            databaseURL:
                'https://stepup-70394-default-rtdb.europe-west1.firebasedatabase.app/')
        .ref()
        .child('count');

    // Update steps to Firebase
    stepRef.set(stepsTaken).then((_) {
      print("Steps successfully updated in Firebase"); // Log success
    }).catchError((error) {
      // Log error
      print("Failed to update steps to Firebase: $error");
    });

    notifyListeners();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
    notifyListeners();
  }

  void onPedestrianStatusError(error) {
    _status = 'Pedestrian Status not available';
    notifyListeners();
  }

  void onStepCountError(error) {
    _steps = 'Step Count not available';
    notifyListeners();
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  void _startResetTimer() {
    final now = DateTime.now();
    final nextResetTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final initialDelay = nextResetTime.isBefore(now)
        ? nextResetTime.add(const Duration(days: 1)).difference(now)
        : nextResetTime.difference(now);

    _resetTimer = Timer(initialDelay, () {
      resetSteps();
      _resetTimer = Timer.periodic(const Duration(days: 1), (timer) {
        resetSteps();
      });
    });
  }

  void _startSecondTimer() {
    _secondTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final nextResetTime = DateTime(now.year, now.month, now.day, 24, 0, 0);
      final timeRemaining = nextResetTime.isBefore(now)
          ? nextResetTime.add(const Duration(days: 1)).difference(now)
          : nextResetTime.difference(now);

      _timeUntilReset = timeRemaining.toString().split('.').first;
      notifyListeners();
    });
  }

  void resetSteps() {
    _initialSteps = 0;
    _isInitialStepCountSet = false;
    _steps = '0';
    _distanceInKm = 0.0;

    // Get the Firebase app and create a reference to the database
    final firebaseApp = Firebase.app();
    DatabaseReference stepRef = FirebaseDatabase.instanceFor(
            app: firebaseApp,
            databaseURL:
                'https://stepup-70394-default-rtdb.europe-west1.firebasedatabase.app/')
        .ref()
        .child('count');

    // Reset steps to 0 in Firebase
    stepRef.set(0).then((_) {
      print("Steps successfully reset to 0 in Firebase"); // Log success
    }).catchError((error) {
      // Log error
      print("Failed to reset steps to 0 in Firebase: $error");
    });

    notifyListeners();
  }

  @override
  void dispose() {
    _resetTimer.cancel();
    _secondTimer.cancel();
    super.dispose();
  }
}
