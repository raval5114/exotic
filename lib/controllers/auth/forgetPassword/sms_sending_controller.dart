import 'dart:ui';

import 'package:exotic/controllers/auth/Signup/src/textfield.dart';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SmssendingscreenComponent extends StatefulWidget {
  const SmssendingscreenComponent({super.key});

  @override
  State<SmssendingscreenComponent> createState() =>
      _SmssendingscreenComponentState();
}

class _SmssendingscreenComponentState extends State<SmssendingscreenComponent>
    with TickerProviderStateMixin, CodeAutoFill {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  late AnimationController _successController;
  late Animation<double> _successAnimation;

  bool _isError = false;
  bool _isSuccess = false;

  @override
  void codeUpdated() {
    if (code != null && code!.isNotEmpty && mounted) {
      setState(() => _otpController.text = code!);
      if (_otpController.text.length == 4) onOtpSubmit();
    }
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    // Entry animation
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

    // Shake on error
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 24)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_shakeController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) _shakeController.reset();
    });

    // Success pulse
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
  }

  void _triggerErrorAnimation() {
    setState(() {
      _isError = true;
      _isSuccess = false;
    });
    _shakeController.forward();
  }

  void _triggerSuccessAnimation() {
    setState(() {
      _isSuccess = true;
      _isError = false;
    });
    _successController.forward();
  }

  String maskMobile(String mobile) {
    if (mobile.length < 6) return mobile;
    return '${mobile.substring(0, 2)}${'*' * (mobile.length - 4)}${mobile.substring(mobile.length - 2)}';
  }

  void _onCancel() => context.pop();

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

  void onOtpSend(String email, String mobileno) {
    setState(() {
      _otpController.clear();
      _isError = false;
      _isSuccess = false;
    });
    _successController.reset();
    listenForCode();
    context.read<AuthBloc>().add(
      AuthOTPSentInternalEvent(email: email, mobileno: mobileno),
    );
  }

  Future<void> setEmailAndPasswordPrefs(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  @override
  void dispose() {
    cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    _fadeController.dispose();
    _shakeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  // ── OTP digit boxes ─────────────────────────────────────────────────────────
  Widget _otpBoxes(AppTheme t) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder:
          (context, child) => Transform.translate(
            offset: Offset(_isError ? -_shakeAnimation.value * 1.5 : 0, 0),
            child: child,
          ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hidden real text field that handles keyboard
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
                  if (val.length == 4) onOtpSubmit();
                },
              ),
            ),
          ),

          // Visible styled boxes
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_otpFocusNode.hasFocus) _otpFocusNode.unfocus();
              Future.delayed(const Duration(milliseconds: 50), () {
                if (mounted) FocusScope.of(context).requestFocus(_otpFocusNode);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final char =
                    _otpController.text.length > index
                        ? _otpController.text[index]
                        : '';
                bool isFocused =
                    _otpFocusNode.hasFocus &&
                    _otpController.text.length == index;
                if (_otpController.text.length == 4 && index == 3) {
                  isFocused = _otpFocusNode.hasFocus;
                }

                Color bgColor;
                Color borderColor;
                List<BoxShadow> shadows = [];

                if (_isError) {
                  bgColor = const Color(0xFFFEF2F2);
                  borderColor = t.brandPink;
                } else if (_isSuccess) {
                  bgColor = const Color(0xFFF0FDF4);
                  borderColor = const Color(0xFF16A34A);
                  shadows = [
                    BoxShadow(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ];
                } else if (isFocused) {
                  bgColor = Colors.white;
                  borderColor = t.brandPrimary;
                  shadows = [
                    BoxShadow(
                      color: t.brandPrimary.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ];
                } else if (char.isNotEmpty) {
                  bgColor = t.brandPrimary.withValues(alpha: 0.06);
                  borderColor = t.brandPrimary.withValues(alpha: 0.3);
                } else {
                  bgColor = Colors.white.withValues(alpha: 0.5);
                  borderColor = Colors.white.withValues(alpha: 0.6);
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  width: 56,
                  height: 66,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(t.radiusMD),
                    border: Border.all(
                      color: borderColor,
                      width: isFocused || _isError || _isSuccess ? 2 : 1.5,
                    ),
                    boxShadow: shadows,
                  ),
                  child: Text(
                    char,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color:
                          _isError
                              ? t.brandPink
                              : _isSuccess
                              ? const Color(0xFF16A34A)
                              : Colors.black87,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOTPVerifiedState) {
            _triggerSuccessAnimation();
            Future.delayed(const Duration(milliseconds: 800), () {
              if (!mounted) return;
              context.read<UserLoginProvider>().clearOtp();
              setEmailAndPasswordPrefs(
                context.read<UserLoginProvider>().email,
                context.read<UserLoginProvider>().password,
              );
              context.read<UserLoginProvider>().clearCredentials();
              context.go('/home');
            });
          } else if (state is AuthErrorState) {
            _triggerErrorAnimation();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: t.brandPink,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.radiusSM),
                ),
              ),
            );
          }
          if (state is AuthOTPSentState) {
            context.read<UserLoginProvider>().setOtp(state.otp);
          }
        },
        builder: (context, state) {
          final email = context.read<UserLoginProvider>().email;
          final mobileno = context.read<UserLoginProvider>().mobileno;
          final isVerifying = state is AuthLoadingState;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Blob background ───────────────────────────────────────────
              Image.asset(
                'assets/src/login_blob_2.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: AlignmentDirectional.topStart,
                errorBuilder:
                    (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            t.brandPrimary,
                            const Color(0xFF5B21B6),
                            t.brandSecondary,
                          ],
                        ),
                      ),
                    ),
              ),

              // ── Content ───────────────────────────────────────────────────
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: t.spaceXXL),
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ── Glassmorphism card ─────────────────────
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  t.radiusLG + 8,
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 18,
                                    sigmaY: 18,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.55,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        t.radiusLG + 8,
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.06,
                                          ),
                                          blurRadius: 32,
                                          offset: const Offset(0, 16),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: t.spaceXXL,
                                      vertical: t.spaceXXL + 8,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // ── Icon badge ─────────────────
                                        ScaleTransition(
                                          scale:
                                              _isSuccess
                                                  ? _successAnimation
                                                  : const AlwaysStoppedAnimation(
                                                    1.0,
                                                  ),
                                          child: Container(
                                            padding: EdgeInsets.all(
                                              t.spaceXL - 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  _isSuccess
                                                      ? const Color(
                                                        0xFF16A34A,
                                                      ).withValues(alpha: 0.12)
                                                      : Colors.white.withValues(
                                                        alpha: 0.8,
                                                      ),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: (_isSuccess
                                                          ? const Color(
                                                            0xFF16A34A,
                                                          )
                                                          : t.brandPrimary)
                                                      .withValues(alpha: 0.2),
                                                  blurRadius: 16,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              _isSuccess
                                                  ? Icons.check_circle_rounded
                                                  : Icons.sms_outlined,
                                              size: 42,
                                              color:
                                                  _isSuccess
                                                      ? const Color(0xFF16A34A)
                                                      : t.brandPrimary,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: t.spaceXXL),

                                        // ── Headline ─────────────────────
                                        Text(
                                          _isSuccess
                                              ? 'Verified! ✅'
                                              : 'Enter OTP',
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black87,
                                                letterSpacing: 0.3,
                                              ),
                                        ),
                                        SizedBox(height: t.spaceXS),
                                        Text(
                                          _isSuccess
                                              ? 'Login successful. Redirecting…'
                                              : 'We sent a 4-digit code to',
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: Colors.black54,
                                                height: 1.5,
                                              ),
                                        ),
                                        if (!_isSuccess) ...[
                                          SizedBox(height: t.spaceXS),
                                          Text(
                                            mobileno.isNotEmpty
                                                ? maskMobile(mobileno)
                                                : '**********',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  color: t.brandPrimary,
                                                  letterSpacing: 2.0,
                                                ),
                                          ),
                                        ],

                                        SizedBox(height: t.spaceXXL),

                                        // ── OTP boxes ────────────────────
                                        _otpBoxes(t),

                                        // ── Status message ────────────────
                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          child:
                                              _isError
                                                  ? Padding(
                                                    key: const ValueKey('err'),
                                                    padding: EdgeInsets.only(
                                                      top: t.spaceSM,
                                                    ),
                                                    child: Text(
                                                      'Invalid OTP. Please try again.',
                                                      style: theme
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            color: t.brandPink,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  )
                                                  : _isSuccess
                                                  ? Padding(
                                                    key: const ValueKey('ok'),
                                                    padding: EdgeInsets.only(
                                                      top: t.spaceSM,
                                                    ),
                                                    child: Text(
                                                      'OTP verified!',
                                                      style: theme
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            color: const Color(
                                                              0xFF16A34A,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  )
                                                  : const SizedBox(
                                                    key: ValueKey('none'),
                                                  ),
                                        ),

                                        SizedBox(height: t.spaceXXL),

                                        // ── Primary action ───────────────
                                        if (!_isSuccess)
                                          AuthPrimaryButton(
                                            label:
                                                isVerifying
                                                    ? 'Verifying…'
                                                    : 'Verify OTP',
                                            isLoading: isVerifying,
                                            onPressed: onOtpSubmit,
                                          ),

                                        SizedBox(height: t.spaceMD),

                                        // ── Links row ────────────────────
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: _onCancel,
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.black54,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        t.radiusSM,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                'Back',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black54,
                                                    ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => onOtpSend(
                                                    email,
                                                    mobileno,
                                                  ),
                                              style: TextButton.styleFrom(
                                                foregroundColor: t.brandPrimary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        t.radiusSM,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                'Resend OTP',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: t.brandPrimary,
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

                              SizedBox(height: t.spaceLG),

                              // ── Legal text ──────────────────────────────
                              Text(
                                'Your code expires in 10 minutes',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  height: 1.5,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
