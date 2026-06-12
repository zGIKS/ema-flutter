import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/users/create_user_cubit.dart';
import '../pages/users/create_user_state.dart';

class UserFormWidget extends StatefulWidget {
  const UserFormWidget({super.key});

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<CreateUserCubit>().submitForm(
            username: _usernameController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateUserCubit, CreateUserState>(
      listener: (context, state) {
        if (state.status == CreateUserStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.createdUser?.username ?? 'User'} created successfully'),
              backgroundColor: const Color(0xFF16A34A),
            ),
          );
          Navigator.of(context).pop(true);
        } else if (state.status == CreateUserStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error occurred')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == CreateUserStatus.loading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Username',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF4B5563)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _usernameController,
                textCapitalization: TextCapitalization.none,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]'))],
                decoration: InputDecoration(
                  hintText: 'mateo',
                  hintStyle: const TextStyle(color: Color(0xFFA0AABF)),
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF4B5563)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6B7280)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6B7280)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
                  ),
                ),
                validator: (value) {
                  final normalized = value?.trim().toLowerCase() ?? '';
                  if (!RegExp(r'^[a-z]{3,30}$').hasMatch(normalized)) {
                    return 'Use only letters, 3 to 30 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF4B5563)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Admin12345!A',
                  hintStyle: const TextStyle(color: Color(0xFFA0AABF)),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4B5563)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: const Color(0xFF64748B),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6B7280)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6B7280)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
                  ),
                ),
                validator: (value) {
                  final password = value ?? '';
                  if (password.length < 12) {
                    return 'Password must be at least 12 characters';
                  }
                  if (!RegExp(r'[a-z]').hasMatch(password)) {
                    return 'Password must include a lowercase letter';
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(password)) {
                    return 'Password must include an uppercase letter';
                  }
                  if (!RegExp(r'\d').hasMatch(password)) {
                    return 'Password must include a digit';
                  }
                  if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
                    return 'Password must include a symbol';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.person_add_alt_1),
                  label: Text(
                    isLoading ? 'Creating...' : 'Create User',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
