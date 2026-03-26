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
      body: BlocListener<HomepageBloc, HomepageState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is HomepageLoadingState) {
            debugPrint("Loading state");
          }
          if (state is HomepagePagesFetchedState) {
            debugPrint("EventCalled");
            //   debugPrint("Data Fetched State:${pages.map((e) => e.slug)}");
          }
          if (state is HomepageErrorState) {
            debugPrint(state.errMsg);
          }
        },
        child: Center(),
      ),
    );
  }
}
