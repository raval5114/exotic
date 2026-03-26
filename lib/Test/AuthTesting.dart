import 'package:exotic/controllers/auth/forgetPassword/email_sending_controller.dart';
import 'package:exotic/data/domains/auth/auth.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthTesting extends StatelessWidget {
  const AuthTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: ChangeNotifierProvider(
        create: (_) => UserLoginProvider(),
        child: const AuthTestingComponent(),
      ),
    );
  }
}

class AuthTestingComponent extends StatefulWidget {
  const AuthTestingComponent({super.key});

  @override
  State<AuthTestingComponent> createState() => _AuthTestingComponentState();
}

class _AuthTestingComponentState extends State<AuthTestingComponent> {
  // final AuthService service = AuthService();
  // final TextEditingController otpController = TextEditingController();

  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserLoginProvider>().email = "hariraval81@gmail.com";
      context.read<UserLoginProvider>().mobileno =
          "1234567890"; // Mocking as well
    });
    //_sendOtp();
  }

  // Future<void> _sendOtp() async {
  //   setState(() => isLoading = true);

  //   try {
  //     final otp = await service.sendOtpEmail("hariraval81@gmail.com");

  //     if (!mounted) return;

  //     context.read<UserLoginProvider>().setOtp(otp);

  //     debugPrint("Stored OTP in provider: $otp");
  //   } catch (e) {
  //     debugPrint("OTP sending failed: $e");
  //   }

  //   if (mounted) {
  //     setState(() => isLoading = false);
  //   }
  // }

  // void _verifyOtp() {
  //   final input = int.tryParse(otpController.text.trim());

  //   if (input == null) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("Enter valid 4 digit OTP")));
  //     return;
  //   }

  //   final isValid = context.read<UserLoginProvider>().verifyOtp(input);

  //   if (isValid) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("✅ OTP Verified")));
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("❌ Invalid OTP")));
  //   }
  // }

  @override
  void dispose() {
    // otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EmailSendingController(email: "hariraval81@gmail.com");
  }

  //   Scaffold(
  //     appBar: AppBar(title: const Text("Auth Testing")),
  //     body: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           if (isLoading) const CircularProgressIndicator(),
  //           const SizedBox(height: 20),
  //           TextField(
  //             controller: otpController,
  //             keyboardType: TextInputType.number,
  //             maxLength: 4,
  //             decoration: const InputDecoration(
  //               hintText: "Enter OTP",
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: _verifyOtp,
  //             child: const Text("Verify OTP"),
  //           ),
  //           const SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: _sendOtp,
  //             child: const Text("Resend OTP"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
