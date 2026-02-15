import 'package:flutter/material.dart';

class Signinwithcredentials extends StatelessWidget {
  const Signinwithcredentials({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SigninwithcredentialsCompoments());
  }
}

class SigninwithcredentialsCompoments extends StatefulWidget {
  const SigninwithcredentialsCompoments({super.key});

  @override
  State<SigninwithcredentialsCompoments> createState() =>
      _SigninwithcredentialsCompomentsState();
}

class _SigninwithcredentialsCompomentsState
    extends State<SigninwithcredentialsCompoments> {
  void onClickEvent() {}
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => onClickEvent,
            child: Text("On Verifting credentials"),
          ),
        ],
      ),
    );
  }
}
