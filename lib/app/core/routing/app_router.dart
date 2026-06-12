import 'package:flutter/material.dart';

import '../../iam/interfaces/pages/users/create_user.screen.dart';
import '../../identity/interfaces/pages/person_profile/person_profile.screen.dart';
import '../../identity/interfaces/pages/register_person/register_person.screen.dart';

class AppRouter {
  AppRouter._();

  static Future<void> openPersonProfile(
    BuildContext context, {
    required String personId,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PersonProfileScreen(personId: personId),
      ),
    );
  }

  static Future<void> openRegisterPerson(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RegisterPersonScreen(),
      ),
    );
  }

  static Future<bool?> openCreateUser(BuildContext context) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const CreateUserScreen(),
      ),
    );
  }
}
