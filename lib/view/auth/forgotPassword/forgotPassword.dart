import 'package:exotic/controllers/auth/forgetPassword/forgot_password_controller.dart';
import 'package:flutter/material.dart';

class ForgotpasswordScreen extends StatelessWidget {
  const ForgotpasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: ForgetPasswordComponent(),
    );
  }
}
