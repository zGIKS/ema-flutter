import 'package:flutter/material.dart';

import '../../widgets/app_header.widget.dart';
import '../../widgets/bottom_navigation.widget.dart';
import '../../../../identity/interfaces/pages/home/home.screen.dart';
import '../../../../biometrics/interfaces/pages/identify_person/identify_person.screen.dart';
import '../../../../identity/interfaces/pages/registered_persons/registered_persons.screen.dart';
import '../../../../auditory/interfaces/pages/auditory_logs/auditory_logs.screen.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _tabs = const [
    IdentityHomeScreen(),
    IdentifyPersonScreen(),
    RegisteredPersonsScreen(),
    AuditoryLogsScreen(),
  ];

  void _onTap(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Column(
        children: [
          const AppHeaderWidget(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _tabs,
            ),
          ),
          BottomNavigationWidget(
            selectedIndex: _selectedIndex,
            onTap: _onTap,
          ),
        ],
      ),
    );
  }
}
