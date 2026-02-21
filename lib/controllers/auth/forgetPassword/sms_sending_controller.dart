import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmssendingscreenComponent extends StatefulWidget {
  const SmssendingscreenComponent({super.key});

  @override
  State<SmssendingscreenComponent> createState() =>
      _SmssendingscreenComponentState();
}

class _SmssendingscreenComponentState extends State<SmssendingscreenComponent> {
  final TextEditingController _otpController = TextEditingController();

  String maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex <= 1 || !email.contains('@')) return email;

    try {
      return email[0] +
          '*' * (atIndex - 2) +
          email[atIndex - 1] +
          email.substring(atIndex);
    } catch (e) {
      return email;
    }
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void onOtpSubmit() {
    final otpText = _otpController.text.trim();

    if (otpText.length != 4 || int.tryParse(otpText) == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter valid 4 digit OTP")));
      return;
    }

    context.read<AuthBloc>().add(
      AuthOTPVerifyingEvent(smsCode: int.parse(otpText)),
    );
  }

  void onOtpSend(String email) {
    context.read<AuthBloc>().add(AuthOTPSentInternalEvent(email: email));
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void setEmailAndPasswordPrefs(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("password", password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOTPVerifiedState) {
          context.read<UserLoginProvider>().clearOtp();
          setEmailAndPasswordPrefs(
            context.read<UserLoginProvider>().email,
            context.read<UserLoginProvider>().password,
          );
          context.read<UserLoginProvider>().clearCredentials();
          context.go('/home');
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is AuthOTPSentState) {
          context.read<UserLoginProvider>().setOtp(state.otp);
        }
      },
      builder: (context, state) {
        final email = context.read<UserLoginProvider>().email;

        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/src/login_blob_2.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 150),
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 45,
                          child: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'OTP Sent',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Enter the 4-digit code sent to your email',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        maskEmail(email),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: _otpController,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            if (value.length == 4) {
                              onOtpSubmit();
                            }
                          },

                          style: const TextStyle(
                            fontSize: 24,
                            letterSpacing: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.pinkAccent,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            hintText: '____',
                            hintStyle: const TextStyle(
                              letterSpacing: 16,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: onOtpSubmit,
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => onOtpSend(email),
                          child: const Text(
                            'Send Again',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _onCancel,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 14, color: Colors.black45),
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
}
