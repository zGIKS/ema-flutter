import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/routing/app_router.dart';
import '../../../application/internal/queryservices/person_directory_query_service_impl.dart';
import '../../../infrastructure/api/gateways/person.gateway.dart';
import '../../../../shared/interfaces/widgets/material_loading.widget.dart';
import '../../../../shared/interfaces/widgets/primary_fab_button.widget.dart';

import 'registered_persons_cubit.dart';
import 'registered_persons_state.dart';

class RegisteredPersonsScreen extends StatefulWidget {
  final bool isActive;

  const RegisteredPersonsScreen({super.key, required this.isActive});

  @override
  State<RegisteredPersonsScreen> createState() =>
      _RegisteredPersonsScreenState();
}

class _RegisteredPersonsScreenState extends State<RegisteredPersonsScreen> {
  late final RegisteredPersonsCubit _cubit;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final dio = AppDependencies.createDio();
    final gateway = PersonHttpGateway(dio);
    final queryService = PersonDirectoryQueryServiceImpl(gateway);
    _cubit = RegisteredPersonsCubit(queryService: queryService);
    if (widget.isActive) {
      _cubit.loadPersons(clearPage: true);
    }
  }

  @override
  void didUpdateWidget(covariant RegisteredPersonsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      _searchController.clear();
      _cubit.loadPersons(clearPage: true);
    }
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.border),
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
                  hintStyle: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.textHint),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<RegisteredPersonsCubit, RegisteredPersonsState>(
                builder: (context, state) {
                  if (state.status == RegisteredPersonsStatus.loading ||
                      state.status == RegisteredPersonsStatus.initial) {
                    return const MaterialLoadingWidget();
                  }

                  if (state.status == RegisteredPersonsStatus.failure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.errorMessage ??
                                  'Unable to load registered persons',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<RegisteredPersonsCubit>()
                                  .loadPersons(clearPage: true),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final page = state.page;
                  if (page == null || page.items.isEmpty) {
                    return const Center(
                      child: Text('No registered persons yet'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<RegisteredPersonsCubit>()
                        .loadPersons(clearPage: true),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 8, bottom: 88),
                      itemCount: page.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final person = page.items[index];
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.avatarBackground,
                              foregroundColor: AppColors.primaryDark,
                              backgroundImage: person.imageUrl != null &&
                                      person.imageUrl!.isNotEmpty
                                  ? NetworkImage(person.imageUrl!)
                                  : null,
                              child: person.imageUrl != null &&
                                      person.imageUrl!.isNotEmpty
                                  ? null
                                  : Text(
                                      person.firstName.isNotEmpty
                                          ? person.firstName[0].toUpperCase()
                                          : '?',
                                    ),
                            ),
                            title: Text(
                              '${person.firstName} ${person.lastName}',
                            ),
                            subtitle: Text('DNI ${person.dni}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => AppRouter.openPersonProfile(
                              context,
                              personId: person.uuid,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: PrimaryFabButton(
                onTap: () => AppRouter.openRegisterPerson(context),
                icon: Icons.person_add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
