import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/app_dependencies.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../shared/interfaces/widgets/material_loading.widget.dart';
import '../../../application/internal/commandservices/users_command_service_impl.dart';
import '../../../application/internal/queryservices/users_query_service_impl.dart';
import '../../../domain/model/valueobjects/user_role.valueobject.dart';
import '../../../infrastructure/api/gateways/users.gateway.dart';
import '../../widgets/edit_user_role_sheet.widget.dart';
import 'users_cubit.dart';
import 'users_state.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final UsersCubit _cubit;

  @override
  void initState() {
    super.initState();
    final dio = AppDependencies.createDio();
    final gateway = UsersHttpGateway(dio);
    _cubit = UsersCubit(
      queryService: UsersQueryServiceImpl(gateway),
      commandService: UsersCommandServiceImpl(gateway),
    );
    _cubit.loadUsers();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _openCreateUserFlow() async {
    final created = await AppRouter.openCreateUser(context);
    if (created == true && mounted) {
      await _cubit.loadUsers();
    }
  }

  Future<void> _openRoleEditor({
    required String userId,
    required String username,
    required UserRole currentRole,
  }) async {
    final selectedRole = await showModalBottomSheet<UserRole>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF8F9FC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => EditUserRoleSheet(
        username: username,
        currentRole: currentRole,
      ),
    );

    if (selectedRole == null || !mounted) {
      return;
    }

    try {
      await _cubit.updateUserRole(userId: userId, role: selectedRole);
      await _cubit.loadUsers(clearUsers: false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User role updated successfully'),
            backgroundColor: Color(0xFF16A34A),
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '').trim()),
        ),
      );
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Users',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage app accounts and roles.',
            style: TextStyle(
              color: Color(0xFFD7E3FF),
              fontSize: 14,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: _openCreateUserFlow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0F172A),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text(
                'Add user',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<UsersCubit, UsersState>(
                builder: (context, state) {
                  if (state.status == UsersStatus.initial || state.status == UsersStatus.loading) {
                    return const MaterialLoadingWidget(itemCount: 4);
                  }

                  if (state.status == UsersStatus.failure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.errorMessage ?? 'Unable to load users',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF1F2937)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<UsersCubit>().loadUsers(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.users.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.people_outline, size: 48, color: Color(0xFF94A3B8)),
                            const SizedBox(height: 12),
                            const Text(
                              'No users yet',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Create the first account from the button above.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _openCreateUserFlow,
                              icon: const Icon(Icons.person_add_alt_1),
                              label: const Text('Add user'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context.read<UsersCubit>().loadUsers(),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: state.users.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        final role = user.role.isNotEmpty ? UserRole.fromValue(user.role) : UserRole.user;
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF2FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.person, color: Color(0xFF1D4ED8)),
                            ),
                            title: Text(
                              user.username,
                              style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                role.label,
                                style: const TextStyle(color: Color(0xFF64748B)),
                              ),
                            ),
                            trailing: const Icon(Icons.expand_more, color: Color(0xFF64748B)),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: OutlinedButton.icon(
                                  onPressed: () => _openRoleEditor(
                                    userId: user.userId,
                                    username: user.username,
                                    currentRole: role,
                                  ),
                                  icon: const Icon(Icons.edit_outlined),
                                  label: const Text('Edit role'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
