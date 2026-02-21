import 'package:exotic/controllers/auth/Signup/src/textfield.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:exotic/view/auth/Signin/subscreens/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninComponent extends StatefulWidget {
  const SigninComponent({super.key});

  @override
  State<SigninComponent> createState() => _SigninComponentState();
}

class _SigninComponentState extends State<SigninComponent> {
  final TextEditingController _email = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void _onSubmit() {
    context.read<UserLoginProvider>().email = _email.text.toString();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordScreen()),
    );
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Custom-painted blobs
        Image.asset(
          'assets/src/login_blob.png',
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        // Login form
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 350),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Good to see you back!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 19,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '❤',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  buildRoundedTextField(
                    hint: 'email',
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        maximumSize: Size(335, 61),
                        backgroundColor: const Color(0xFF9747FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      child:
                          _isLoading == true
                              ? CircularProgressIndicator()
                              : Text(
                                'Next',
                                style: TextStyle(
                                  fontFamily: 'nunitoSans',
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: _onCancel,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'nunitoSans',
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
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
  }
}
