import 'package:flutter/material.dart';
import '../../../biometrics/interfaces/pages/identify_person/identify_person.screen.dart';
import '../../../iam/interfaces/pages/users/users.screen.dart';
import '../../../identity/interfaces/pages/registered_persons/registered_persons.screen.dart';
import '../../../auditory/interfaces/pages/auditory_logs/auditory_logs.screen.dart';
import '../../../iam/application/internal/session_manager.dart';
import 'bottom_navigation.widget.dart';

class AppShellWidget extends StatefulWidget {
  const AppShellWidget({super.key});

  @override
  State<AppShellWidget> createState() => _AppShellWidgetState();
}

class _AppShellWidgetState extends State<AppShellWidget> {
  int _selectedIndex = 0;

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
    final isAdmin = SessionManager.isAdmin;
    final tabs = isAdmin
        ? [
            const UsersScreen(),
            IdentifyPersonScreen(isActive: _selectedIndex == 1),
            RegisteredPersonsScreen(isActive: _selectedIndex == 2),
            AuditoryLogsScreen(isActive: _selectedIndex == 3),
          ]
        : [
            IdentifyPersonScreen(isActive: _selectedIndex == 0),
            AuditoryLogsScreen(isActive: _selectedIndex == 1),
          ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      color: Color(0xFF2563EB),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD1D5DB), width: 2),
                      color: const Color(0xFFF3F4F6),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF6B7280),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: tabs,
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
