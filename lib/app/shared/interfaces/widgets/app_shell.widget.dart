import 'package:flutter/material.dart';
import '../../../biometrics/interfaces/pages/identify_person/identify_person.screen.dart';
import '../../../core/routing/app_router.dart';
import '../../../iam/interfaces/pages/users/users.screen.dart';
import '../../../identity/interfaces/pages/registered_persons/registered_persons.screen.dart';
import '../../../auditory/interfaces/pages/auditory_logs/auditory_logs.screen.dart';
import '../../../iam/application/internal/session_manager.dart';
import 'app_header.widget.dart';
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
          AppHeaderWidget(onProfileTap: () => AppRouter.openAccount(context)),
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
