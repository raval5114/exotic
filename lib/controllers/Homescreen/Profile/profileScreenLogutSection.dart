import 'package:exotic/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenLogoutSection extends StatefulWidget {
  const ProfileScreenLogoutSection({super.key});

  @override
  State<ProfileScreenLogoutSection> createState() =>
      _ProfileScreenLogoutSectionState();
}

class _ProfileScreenLogoutSectionState
    extends State<ProfileScreenLogoutSection> {
  void onPressed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("password");

    final email = prefs.getString("email");
    final password = prefs.getString("password");

    print("Email after remove: $email"); // Should print: null
    print("Password after remove: $password"); // Should print: null

    context.read<UserProvider>().clearUser();
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Color(0xFF9747FF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Log out",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9747FF),
            ),
          ),
        ),
      ),
    );
  }
}
