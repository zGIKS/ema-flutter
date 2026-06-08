import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/interfaces/widgets/app_header.widget.dart';
import '../../../../shared/interfaces/widgets/bottom_navigation.widget.dart';
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
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final gateway = PersonHttpGateway(dio);
    final queryService = PersonDirectoryQueryServiceImpl(gateway);
    _cubit = RegisteredPersonsCubit(queryService: queryService);
    _cubit.loadPersons();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _cubit.loadPersons(search: query.isNotEmpty ? query : null);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
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
            const AppHeaderWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search by DNI or name',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ),
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
                              backgroundImage: person.imageUrl != null && person.imageUrl!.isNotEmpty
                                  ? NetworkImage(person.imageUrl!)
                                  : null,
                              child: person.imageUrl != null && person.imageUrl!.isNotEmpty
                                  ? null
                                  : Text(person.firstName.isNotEmpty ? person.firstName[0].toUpperCase() : '?'),
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
            BottomNavigationWidget(
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
