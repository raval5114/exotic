import 'package:exotic/controllers/auth/forgetPassword/email_sending_controller.dart';
import 'package:flutter/material.dart';

class EmailSendingScreen extends StatefulWidget {
  final String email;
  const EmailSendingScreen({super.key, required this.email});

  @override
  State<EmailSendingScreen> createState() => _EmailSendingScreenState();
}

class _EmailSendingScreenState extends State<EmailSendingScreen> {
  @override
  Widget build(BuildContext context) {
    return EmailSendingController(email: widget.email);
  }
}
