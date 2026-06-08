import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../widgets/register_form.widget.dart';
import 'register_person_cubit.dart';
import '../../../application/internal/commandservices/person_command_service_impl.dart';
import '../../../infrastructure/api/gateways/person.gateway.dart';

class RegisterPersonScreen extends StatelessWidget {
  const RegisterPersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Register New Person',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) {
          final dio = AppDependencies.createDio();
          final gateway = PersonHttpGateway(dio);
          final service = PersonCommandServiceImpl(gateway);
          return RegisterPersonCubit(commandService: service);
        },
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: RegisterFormWidget(),
        ),
      ),
    );
  }
}
