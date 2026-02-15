import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiginPageTesting extends StatelessWidget {
  const SiginPageTesting({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    void onSubmit() {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      //context.read<AuthService>().
      debugPrint('''Email:${email}\nPassword:${password}''');
      context.read<AuthBloc>().add(AuthOTPSentInternalEvent(email: email));
      // context.read<AuthBloc>().add(
      //   SigninEvent(
      //     email: _emailController.text.trim(),
      //     password: _passwordController.text.trim(),
      //   ),
      // );
    }

    void showSnackBar(BuildContext context, String text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Sign In Testing")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {}
          if (state is AuthSigninSuccessState) {
            showSnackBar(
              context,
              "Login Succesfull id:${state.data['user']['c_id']}",
            );
          }
          if (state is AuthErrorState) {
            showSnackBar(context, "Error:${state.message}");
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(label: Text("Enter Email")),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(label: Text("Enter Password")),
              ),
              SizedBox(height: 30),
              ElevatedButton(onPressed: onSubmit, child: Text("Submit")),
            ],
          );
        },
      ),
    );
  }
}
