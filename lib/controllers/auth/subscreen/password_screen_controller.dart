import 'dart:ui';
import 'package:exotic/controllers/auth/src/alertDailog.dart';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/models/user.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/view/auth/forgotPassword/SmsSendingScreen.dart';
import 'package:exotic/view/auth/forgotPassword/forgotPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PasswordScreenComponent extends StatefulWidget {
  const PasswordScreenComponent({super.key});

  @override
  State<PasswordScreenComponent> createState() =>
      _PasswordScreenComponentState();
}

class _PasswordScreenComponentState extends State<PasswordScreenComponent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final email = context.read<UserLoginProvider>().email;
    final password = _controller.text.trim();
    debugPrint("Email: ${email}\nPassword:${password}");
    if (password.isEmpty) {
      showCustomAlertBox(
        context: context,
        type: AlertType.error,
        errors: ["Please fill Something in password field"],
        message: 'Password cannot be empty',
        onOkay: () => Navigator.of(context).pop(),
      );
      return;
    }

    setState(() => _isLoading = true);

    context.read<UserLoginProvider>().password = password;

    context.read<AuthBloc>().add(
      SigninEvent(
        email: context.read<UserLoginProvider>().email,
        password: password,
        mobileNo: context.read<UserLoginProvider>().mobileno,
      ),
    );
  }

  void _onCancel() => Navigator.pop(context);

  void _onForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotpasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          setState(() => _isLoading = true);
        }

        if (state is AuthSigninSuccessState) {
          setState(() => _isLoading = false);

          debugPrint("✅ User logged in: ${state.data['user']}");
          context.read<UserProvider>().setUser(
            User.fromJson(state.data['user']),
          );
          String email = context.read<UserProvider>().user!.email;
          String mobileno = context.read<UserProvider>().user!.phone;
          context.read<AuthBloc>().add(
            AuthOTPSentInternalEvent(email: email, mobileno: mobileno),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SmsSendingScreen()),
          );
        }

        if (state is AuthOTPSentState) {
          setState(() => _isLoading = false);
        }

        if (state is AuthErrorState) {
          setState(() => _isLoading = false);
          showCustomAlertBox(
            context: context,
            message: state.message,
            errors: state.errors,
            onOkay: () {
              Navigator.of(context);
              Navigator.pop(context);
            },
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            // Background blob
            Positioned.fill(
              child: Image.asset(
                'assets/src/login_blob_2.png',
                fit: BoxFit.cover,
                alignment: AlignmentDirectional.topStart,
              ),
            ),

            // Main UI
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.6),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28.0,
                              vertical: 36.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.pinkAccent.withOpacity(
                                          0.2,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person_outline_rounded,
                                    size: 45,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Hello, ${context.read<UserLoginProvider>().username}!',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Type your password to proceed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 36),

                                // Password Input
                                TextFormField(
                                  controller: _controller,
                                  obscureText: _obscureText,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter password',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.6),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Colors.pinkAccent,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.8),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.pinkAccent,
                                        width: 2.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    suffixIcon:
                                        _isLoading
                                            ? Padding(
                                              padding: const EdgeInsets.all(
                                                14.0,
                                              ),
                                              child: SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.pinkAccent),
                                                ),
                                              ),
                                            )
                                            : IconButton(
                                              icon: Icon(
                                                _obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.grey.shade600,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              },
                                            ),
                                  ),
                                  onFieldSubmitted: (_) => _onSubmit(),
                                ),
                                const SizedBox(height: 48),

                                // Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pinkAccent,
                                      elevation: 8,
                                      shadowColor: Colors.pinkAccent
                                          .withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: _isLoading ? null : _onSubmit,
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Links
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: _onCancel,
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black54,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Back',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _onForgotPassword,
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.pinkAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
