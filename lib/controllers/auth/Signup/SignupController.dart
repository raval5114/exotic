import 'dart:io';

import 'package:exotic/controllers/auth/Signup/src/blobPainter.dart';
import 'package:exotic/controllers/auth/Signup/src/textfield.dart';
import 'package:exotic/controllers/auth/src/alertDailog.dart';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/utils/errorFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignupController extends StatefulWidget {
  const SignupController({super.key});

  @override
  State<SignupController> createState() => _SignupControllerState();
}

class _SignupControllerState extends State<SignupController> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
      imageQuality: 85, // Optional: compress image
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _mobileNumber.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void onSubmit() {
    context.read<AuthBloc>().add(
      SignupEvent(
        firstName: _firstname.text.trim(),
        lastName: _lastname.text.trim(),
        profilePhoto: _selectedImage!,
        username: _username.text.trim(),
        email: _email.text.trim(),
        mobileNumber: _mobileNumber.text.trim(),
        password: _password.text,
      ),
    );
  }

  void onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          setState(() => _isLoading = true);
        }

        if (state is AuthSignupSuccessState) {
          setState(() => _isLoading = false);
          showCustomAlertBox(
            context: context,
            message: "You have successfully signed in!",
            errors: [],
            type: AlertType.success,
            onOkay: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
            },
          );
        }

        if (state is AuthErrorState) {
          setState(() => _isLoading = false);
          showCustomAlertBox(
            context: context,
            message: state.message,
            errors: state.errors,
            type: AlertType.error,
            onOkay: () => Navigator.of(context).pop(),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Positioned(
              top: 100,
              right: 0,
              child: CustomPaint(
                painter: PurpleBlobPainter(),
                size: Size(MediaQuery.of(context).size.width, 300),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Create\nAccount',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.raleway(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF9747FF),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child:
                                _selectedImage == null
                                    ? const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 30,
                                      color: Color(0xFF9747FF),
                                    )
                                    : Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      width: 90,
                                      height: 90,
                                    ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      //fistname
                      buildRoundedTextField(
                        hint: 'First Name',
                        controller: _firstname,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Please enter a username'
                                    : null,
                      ),
                      //lastname
                      buildRoundedTextField(
                        hint: 'Last Name',
                        controller: _lastname,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Please enter a username'
                                    : null,
                      ),

                      // Username
                      buildRoundedTextField(
                        hint: 'Username',
                        controller: _username,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Please enter a username'
                                    : null,
                      ),

                      // Email
                      buildRoundedTextField(
                        hint: 'Email',
                        controller: _email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      // Mobile Number
                      buildRoundedTextField(
                        hint: 'Number',
                        keyboardType: TextInputType.phone,
                        controller: _mobileNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a mobile number';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Enter a valid 10-digit number';
                          }
                          return null;
                        },
                      ),

                      // Password
                      buildRoundedTextField(
                        hint: 'Password',
                        obscureText: _obscurePassword,
                        controller: _password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      // Confirm Password
                      const SizedBox(height: 8),
                      buildRoundedTextField(
                        hint: 'Confirm Password',
                        obscureText: _obscureConfirmPassword,
                        controller: _confirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                              ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Done Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9747FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    if (_formKey.currentState!.validate()) {
                                      onSubmit();
                                    }
                                  },
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                    'Done',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Center(
                        child: TextButton(
                          onPressed: onCancel,
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
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
}
