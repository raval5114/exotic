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

class _PasswordScreenComponentState extends State<PasswordScreenComponent> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

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

          context.read<AuthBloc>().add(AuthOTPSentInternalEvent(email: email));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SmsSendingScreen()),
          );
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/src/login_blob_2.png',
                alignment: AlignmentDirectional.topStart,
              ),
            ),

            // Main UI
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(radius: 45, child: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Hello, ${context.read<UserLoginProvider>().username}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Type your password',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // Password Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon:
                                _isLoading
                                    ? Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                    : IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                          ),
                          onSubmitted: (_) => _onSubmit(),
                        ),
                        const SizedBox(height: 20),
                        InkWell(onTap: _onCancel, child: const Text("Cancel")),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: _onForgotPassword,
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
