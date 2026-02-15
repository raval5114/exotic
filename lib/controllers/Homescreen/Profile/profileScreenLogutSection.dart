import 'package:exotic/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return SizedBox(
      height: 120,
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120.0),
            child: Text(
              "Log out",
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
