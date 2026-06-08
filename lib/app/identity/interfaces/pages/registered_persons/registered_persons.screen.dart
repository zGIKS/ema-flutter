import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/interfaces/widgets/ema_app_header.widget.dart';
import '../../../../shared/interfaces/widgets/ema_bottom_navigation.widget.dart';
import '../../../../biometrics/interfaces/pages/identify_person/identify_person.screen.dart';
import '../../../application/internal/queryservices/person_directory_query_service_impl.dart';
import '../../../infrastructure/api/gateways/person.gateway.dart';
import '../home/home.screen.dart';
import '../register_person/register_person.screen.dart';
import 'registered_persons_cubit.dart';
import 'registered_persons_state.dart';

class RegisteredPersonsScreen extends StatefulWidget {
  const RegisteredPersonsScreen({super.key});

  @override
  State<RegisteredPersonsScreen> createState() => _RegisteredPersonsScreenState();
}

class _RegisteredPersonsScreenState extends State<RegisteredPersonsScreen> {
  late final RegisteredPersonsCubit _cubit;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final gateway = PersonHttpGateway(dio);
    final queryService = PersonDirectoryQueryServiceImpl(gateway);
    _cubit = RegisteredPersonsCubit(queryService: queryService);
    _cubit.loadPersons();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        body: Column(
          children: [
            const EmaAppHeaderWidget(),
            Expanded(
              child: BlocBuilder<RegisteredPersonsCubit, RegisteredPersonsState>(
                builder: (context, state) {
                  if (state.status == RegisteredPersonsStatus.loading || state.status == RegisteredPersonsStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == RegisteredPersonsStatus.failure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.errorMessage ?? 'Unable to load registered persons',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<RegisteredPersonsCubit>().loadPersons(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final page = state.page;
                  if (page == null || page.items.isEmpty) {
                    return const Center(child: Text('No registered persons yet'));
                  }

                  return RefreshIndicator(
                    onRefresh: () => context.read<RegisteredPersonsCubit>().loadPersons(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: page.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final person = page.items[index];
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFE8EEFF),
                              foregroundColor: const Color(0xFF0D47A1),
                              child: Text(person.firstName.isNotEmpty ? person.firstName[0].toUpperCase() : '?'),
                            ),
                            title: Text('${person.firstName} ${person.lastName}'),
                            subtitle: Text('DNI ${person.dni}'),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterPersonScreen()),
                      );
                    },
                    child: const SizedBox(
                      width: 64,
                      height: 64,
                      child: Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            EmaBottomNavigationWidget(
              selectedIndex: 2,
              onTap: (index) {
                if (index == 0) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const IdentityHomeScreen()),
                  );
                  return;
                }

                if (index == 1) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const IdentifyPersonScreen()),
                  );
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
