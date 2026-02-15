import 'package:flutter/material.dart';
import 'package:exotic/controllers/src/appbar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController firstNameController = TextEditingController(
    text: 'Rahul',
  );
  final TextEditingController lastNameController = TextEditingController(
    text: 'Verma',
  );
  final TextEditingController mobileController = TextEditingController(
    text: '+91 8166453211',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'r123@gmail.com',
  );

  bool isEditingMobile = false;
  bool isEditingEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExoticAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Icon instead of profile image
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),

            const SizedBox(height: 30),

            // First Name
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Last Name
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Handle Submit
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.blue,
                shadowColor: Colors.transparent,
                elevation: 0,
              ),
              child: const Text(
                "SUBMIT",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            // Mobile Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mobile Number",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      isEditingMobile
                          ? TextField(
                            controller: mobileController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          )
                          : Text(
                            mobileController.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditingMobile = !isEditingMobile;
                    });
                  },
                  child: Text(
                    isEditingMobile ? "Save" : "Update",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // Email
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email ID",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      isEditingEmail
                          ? TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          )
                          : Text(
                            emailController.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditingEmail = !isEditingEmail;
                    });
                  },
                  child: Text(
                    isEditingEmail ? "Save" : "Update",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
          ],
        ),
      ),
    );
  }
}
