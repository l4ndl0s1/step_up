import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_up/app_settings.dart';
import 'package:step_up/appbar_home_page.dart';
import 'package:step_up/auth.dart';

import 'package:step_up/home_page.dart';
import 'package:step_up/option_screen.dart';
import 'package:step_up/ranking_screen.dart';
import 'package:step_up/step_counter.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _HomePageState();
}

class _HomePageState extends State<Navigation> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const RankingPage(),
    OptionsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pedometerProvider = Provider.of<PedometerProvider>(context);
    final appSettings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: CustomAppBar(
        auth: Auth(),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.emoji_events,
            ),
            label: 'Rankings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff1b2f24),
        onTap: _onItemTapped,
      ),
    );
  }
}
