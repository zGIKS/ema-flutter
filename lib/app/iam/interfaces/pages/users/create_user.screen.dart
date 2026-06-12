import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/app_dependencies.dart';
import '../../../application/internal/commandservices/users_command_service_impl.dart';
import '../../../infrastructure/api/gateways/users.gateway.dart';
import 'create_user_cubit.dart';
import '../../widgets/user_form.widget.dart';

class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create User',
          style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w800),
        ),
      ),
      body: BlocProvider(
        create: (_) {
          final dio = AppDependencies.createDio();
          final gateway = UsersHttpGateway(dio);
          final service = UsersCommandServiceImpl(gateway);
          return CreateUserCubit(commandService: service);
        },
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: UserFormWidget(),
        ),
      ),
    );
  }
}
