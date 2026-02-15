import 'package:exotic/controllers/Homescreen/EditProfile/editProfile.dart';
import 'package:flutter/material.dart';

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
      style: ListTileStyle.drawer,
      tileColor: Colors.white,
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}
