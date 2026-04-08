import 'package:exotic/controllers/Homescreen/EditProfile/editProfile.dart';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProfileScreenOptions extends StatelessWidget {
  const ProfileScreenOptions({super.key});

  Widget buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      tileColor: Colors.white,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF9747FF).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF9747FF), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUpdateUserSuccessState && state.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Profile updated!")));
        }
      },
      child: Column(
        children: [
          // Profile Header Section
          // Container(
          //   color: Colors.white,
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          //   child: Row(
          //     children: [
          //       CircleAvatar(
          //         radius: 30,
          //         backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          //         child: Icon(Icons.person, size: 35, color: Theme.of(context).primaryColor),
          //       ),
          //       const Gap(16),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               user != null ? "${user.firstName} ${user.lastName}" : "Welcome Guest",
          //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //             ),
          //             const Gap(4),
          //             Text(
          //               user?.email ?? "Sign in to see your profile",
          //               style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 2),
          buildSectionTitle("Notification"),
          buildOptionItem(
            Icons.notifications_none,
            "Tap for latest updates and offers",
            () {},
          ),

          const SizedBox(height: 2),
          buildSectionTitle("Account Settings"),
          buildOptionItem(Icons.person_outline, "Edit Profile", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile()),
            );
          }),
          buildOptionItem(
            Icons.credit_card_outlined,
            "Saved Credit / Debit & Gift Cards",
            () {},
          ),
          buildOptionItem(Icons.location_on_outlined, "Saved Addresses", () {}),
          buildOptionItem(Icons.language_outlined, "Select Language", () {}),
          buildOptionItem(
            Icons.notifications_active_outlined,
            "Notification Settings",
            () {},
          ),
          buildOptionItem(Icons.lock_outline, "Privacy Center", () {}),

          const SizedBox(height: 2),
          buildSectionTitle("My Activity"),
          buildOptionItem(Icons.rate_review_outlined, "Reviews", () {}),
          buildOptionItem(
            Icons.question_answer_outlined,
            "Questions & Answers",
            () {},
          ),

          const SizedBox(height: 2),
          buildSectionTitle("Earn with Xotic"),
          buildOptionItem(Icons.storefront_outlined, "Sell on Xotic", () {}),

          const SizedBox(height: 2),
          buildSectionTitle("Feedback & Information"),
          buildOptionItem(
            Icons.description_outlined,
            "Terms, Policies and Licenses",
            () {},
          ),
          buildOptionItem(Icons.help_outline, "Browse FAQs", () {}),
        ],
      ),
    );
  }
}
