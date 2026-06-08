import 'package:flutter/material.dart';
import '../../../../shared/interfaces/widgets/app_header.widget.dart';
import '../../../../shared/interfaces/widgets/bottom_navigation.widget.dart';
import '../../../../biometrics/interfaces/pages/identify_person/identify_person.screen.dart';
import '../registered_persons/registered_persons.screen.dart';

import '../../../../auditory/interfaces/pages/auditory_logs/auditory_logs.screen.dart';

class IdentityHomeScreen extends StatefulWidget {
  const IdentityHomeScreen({super.key});

  @override
  State<IdentityHomeScreen> createState() => _IdentityHomeScreenState();
}

class _IdentityHomeScreenState extends State<IdentityHomeScreen> {
  int _selectedIndex = 0;

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const IdentifyPersonScreen()),
      );
      return;
    }

    if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RegisteredPersonsScreen()),
      );
      return;
    }

    if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuditoryLogsScreen()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Column(
        children: [
          const AppHeaderWidget(),
          const Expanded(child: SizedBox.expand()),
          BottomNavigationWidget(
            selectedIndex: _selectedIndex,
            onTap: _onBottomNavTap,
          ),
        ],
      ),
    );
  }
}
