import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

import '../../../../core/di/app_dependencies.dart';
import '../../../../shared/interfaces/widgets/material_loading.widget.dart';
import '../../../application/internal/session_manager.dart';
import '../../../infrastructure/api/gateways/iam.gateway.dart';
import '../../../../shared/interfaces/widgets/app_shell.widget.dart';
import '../sign_in/sign_in.screen.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool _isBootstrapping = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await SessionManager.loadPersistedSession();
      final gateway = IamHttpGateway(AppDependencies.createDio());

      if (SessionManager.token != null) {
        try {
          final user = await gateway.verifySession();
          await SessionManager.saveSession(
            token: SessionManager.token!,
            username: user.username,
            userId: user.userId,
            role: user.role,
          );
          if (!mounted) {
            return;
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AppShellWidget()),
          );
          return;
        } catch (_) {
          // Fall through to refresh.
        }
      }

      final refreshed = await gateway.refreshSession();
      await SessionManager.saveSession(
        token: refreshed.accessToken,
        username: refreshed.username,
        userId: refreshed.userId,
        role: refreshed.role,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppShellWidget()),
      );
    } catch (e) {
      await SessionManager.clearSession();
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '').trim();
        _isBootstrapping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isBootstrapping) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: MaterialLoadingWidget(itemCount: 2),
      );
    }

    return SignInScreen(errorOverride: _errorMessage);
  }
}
