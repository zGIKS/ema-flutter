import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../domain/model/valueobjects/user_role.valueobject.dart';

class EditUserRoleSheet extends StatefulWidget {
  final String username;
  final UserRole currentRole;

  const EditUserRoleSheet({
    super.key,
    required this.username,
    required this.currentRole,
  });

  @override
  State<EditUserRoleSheet> createState() => _EditUserRoleSheetState();
}

class _EditUserRoleSheetState extends State<EditUserRoleSheet> {
  late UserRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.currentRole;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit role',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textTitle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.username,
              style: const TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<UserRole>(
              initialValue: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Role',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: UserRole.values
                  .map(
                    (role) => DropdownMenuItem(
                      value: role,
                      child: Text(role.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_selectedRole),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
