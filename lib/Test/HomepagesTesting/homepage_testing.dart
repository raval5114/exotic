import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/domains/auth/auth.dart';
import 'package:exotic/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomepageTestingWithService extends StatelessWidget {
  const HomepageTestingWithService({super.key});

  @override
  Widget build(BuildContext context) {
    return HomepageTestingServiceComponent();
  }
}

class HomepageTestingServiceComponent extends StatefulWidget {
  const HomepageTestingServiceComponent({super.key});

  @override
  State<HomepageTestingServiceComponent> createState() =>
      _HomepageTestingServiceComponentState();
}

class _HomepageTestingServiceComponentState
    extends State<HomepageTestingServiceComponent> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _verifyOtpController = TextEditingController();
  int? _otp;
  bool _isLoading = false;
  AuthService _authServce = AuthService();
  @override
  void initState() {
    super.initState();
    context.read<HomepageBloc>().add(HomepagePagesFetchingEvent());
  }

  @override
  void dispose() {
    _otpController.dispose();
    _verifyOtpController.dispose();
    super.dispose();
  }

  void _onOtpSent() async {
    final mobileNo = _otpController.text.trim();
    if (mobileNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a mobile number")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final otp = await _authServce.sendOtpSms(mobileNo);
      setState(() {
        _otp = otp;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("OTP Sent successfully!")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onVerifyOtp() {
    final enteredOtp = _verifyOtpController.text.trim();
    if (enteredOtp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the received OTP")),
      );
      return;
    }

    if (_otp != null && enteredOtp == _otp.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Verified Successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Homepage Testing Component",
          style: TextStyle(fontFamily: "Roboto"),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.call),
                        label: const Text(
                          "Enter Mobile Number",
                          style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _onOtpSent,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text(
                              "Send OTP",
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 16,
                              ),
                            ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _verifyOtpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.message),
                        label: const Text(
                          "Enter OTP",
                          style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _onVerifyOtp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Verify OTP",
                      style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                    ),
                  ),
                ],
              ),
              if (_otp != null) ...[
                const SizedBox(height: 24),
                Text(
                  "Debug OTP: $_otp",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
