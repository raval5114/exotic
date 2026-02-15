import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/domains/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: UpdatePasswordController());
  }
}

class UpdatePasswordController extends StatefulWidget {
  const UpdatePasswordController({super.key});

  @override
  State<UpdatePasswordController> createState() =>
      _UpdatePasswordControllerState();
}

class _UpdatePasswordControllerState extends State<UpdatePasswordController> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>(); // Add a GlobalKey for the form validation
  void onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save password logic if validation is successful
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/src/login_blob_2.png',
                height: 650,
                alignment: AlignmentDirectional.topStart,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  // Wrap the entire form inside a Form widget
                  key: _formKey, // Assign the key to the Form
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 45,
                          child: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Setup New Password",
                        style: GoogleFonts.raleway(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 290,
                        height: 57,
                        child: Text(
                          "Please, setup a new password for your account",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 19,
                            fontWeight: FontWeight.w300,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField("New Password", _newPasswordController),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Confirm Password",
                        _confirmPasswordController,
                      ),
                      const SizedBox(height: 140),
                      ElevatedButton(
                        onPressed: () => onSubmit(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9A4DFF),
                          minimumSize: const Size(335, 61),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w300,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/smsSendingScreen');
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hint is required';
        }

        if (hint == 'New Password' && value.length < 6) {
          return 'Password must be at least 6 characters';
        }

        if (hint == 'Confirm Password' &&
            value != _newPasswordController.text) {
          return 'Passwords do not match';
        }

        return null; // Return null if the validation is successful
      },
      decoration: InputDecoration(
        hintStyle: GoogleFonts.raleway(
          fontWeight: FontWeight.w500,
          fontSize: 17,
          color: const Color(0xFFDCDCDC),
        ),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
