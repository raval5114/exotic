import 'dart:ui';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailSendingController extends StatefulWidget {
  final String email;
  const EmailSendingController({super.key, required this.email});

  @override
  State<EmailSendingController> createState() => _EmailSendingControllerState();
}

class _EmailSendingControllerState extends State<EmailSendingController>
    with TickerProviderStateMixin {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _isError = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(AuthOTPSendingEmailEvent(email: widget.email));

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

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 24)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_shakeController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }

  void _triggerErrorAnimation() {
    setState(() {
      _isError = true;
      _isSuccess = false;
    });
    _shakeController.forward();
  }

  String maskEmail(String email) {
    if (!email.contains('@')) return email;
    var parts = email.split('@');
    if (parts[0].length <= 2) return '${parts[0]}@${parts[1]}';
    return '${parts[0].substring(0, 2)}${'*' * (parts[0].length - 2)}@${parts[1]}';
  }

  void _onCancel() {
    context.pop();
  }

  void onOtpSubmit() {
    final otpText = _otpController.text.trim();

    if (otpText.length != 4 || int.tryParse(otpText) == null) {
      _triggerErrorAnimation();
      return;
    }

    context.read<AuthBloc>().add(
      AuthOTPVerifyingEvent(smsCode: int.parse(otpText)),
    );
  }

  void onOtpSend(String mobileno) {
    setState(() {
      _otpController.clear();
      _isError = false;
      _isSuccess = false;
    });
    context.read<AuthBloc>().add(AuthOTPSendingEmailEvent(email: widget.email));
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _fadeController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void setEmailAndPasswordPrefs(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("password", password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOTPVerifiedState) {
            setState(() {
              _isSuccess = true;
              _isError = false;
            });
            Future.delayed(const Duration(milliseconds: 600), () {
              if (!mounted) return;
              context.read<UserLoginProvider>().clearOtp();
              setEmailAndPasswordPrefs(
                widget.email,
                context.read<UserLoginProvider>().password,
              );
              context.read<UserLoginProvider>().clearCredentials();
              context.go('/home');
            });
          } else if (state is AuthWrongOTPState) {
            _triggerErrorAnimation();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid OTP. Please try again.")),
            );
          } else if (state is AuthErrorState) {
            _triggerErrorAnimation();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is AuthOTPSentState) {
            context.read<UserLoginProvider>().setOtp(state.otp);
          }
        },
        builder: (context, state) {
          final email = widget.email;
          final mobileno = context.read<UserLoginProvider>().mobileno;
          return Stack(
            children: [
              // Blob Background matching mockup
              Positioned(
                top: -80,
                left: -60,
                right: 0,
                height: 400,
                child: Image.asset(
                  'assets/src/login_blob_2.png',
                  fit: BoxFit.cover,
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 180),

                          /// User Avatar
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              backgroundImage: AssetImage(
                                'assets/src/bubble 01.jpg',
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Typography
                          const Text(
                            'OTP',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),

                          const Text(
                            'Enter 4-digits code we sent you\ninto your email address',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            email.isNotEmpty
                                ? maskEmail(email)
                                : '*******@****.***',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 32),

                          /// Custom OTP Four-Box Input
                          AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  _isError ? -_shakeAnimation.value * 1.5 : 0,
                                  0,
                                ),
                                child: child,
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                /// Hidden Text Field handles keyboard gracefully natively
                                Opacity(
                                  opacity: 0,
                                  child: SizedBox(
                                    height: 10,
                                    width: double.infinity,
                                    child: TextField(
                                      controller: _otpController,
                                      focusNode: _otpFocusNode,
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      onChanged: (val) {
                                        setState(() {
                                          _isError = false;
                                          _isSuccess = false;
                                        });
                                        if (val.length == 4) {
                                          onOtpSubmit();
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                /// Visible Blocks matching the Mockup
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (_otpFocusNode.hasFocus) {
                                      _otpFocusNode.unfocus();
                                    }
                                    Future.delayed(
                                      const Duration(milliseconds: 50),
                                      () {
                                        if (mounted) {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(_otpFocusNode);
                                        }
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(4, (index) {
                                      String char = '';
                                      if (_otpController.text.length > index) {
                                        char = _otpController.text[index];
                                      }
                                      bool isFocused =
                                          _otpFocusNode.hasFocus &&
                                          _otpController.text.length == index;
                                      if (_otpController.text.length == 4 &&
                                          index == 3) {
                                        isFocused = _otpFocusNode.hasFocus;
                                      }

                                      // Colors targeting Mockup aesthetics
                                      Color bgColor = Colors.grey.shade200;
                                      Color borderColor = Colors.transparent;

                                      if (_isError) {
                                        borderColor = Colors.redAccent;
                                        bgColor = Colors.red.shade50;
                                      } else if (_isSuccess) {
                                        borderColor = Colors.green;
                                        bgColor = Colors.green.shade50;
                                      } else if (isFocused) {
                                        borderColor = const Color(
                                          0xFFFF528A,
                                        ); // Pink Accent
                                        bgColor = Colors.white;
                                      }

                                      return AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        width: 55,
                                        height: 65,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: borderColor,
                                            width:
                                                isFocused ||
                                                        _isError ||
                                                        _isSuccess
                                                    ? 2
                                                    : 1.5,
                                          ),
                                          boxShadow:
                                              isFocused
                                                  ? [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFFFF528A,
                                                      ).withOpacity(0.2),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ]
                                                  : [],
                                        ),
                                        child: Text(
                                          char,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isError)
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                "Invalid OTP entered.",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else if (_isSuccess)
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                "Success!",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          const SizedBox(height: 40),

                          /// Send Again Button
                          SizedBox(
                            width: 220,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFFF528A,
                                ), // Pink from mockup
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () => onOtpSend(mobileno),
                              child: const Text(
                                'Send Again',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// Cancel Button
                          TextButton(
                            onPressed: _onCancel,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black54,
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
