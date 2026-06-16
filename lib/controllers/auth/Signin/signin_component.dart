import 'dart:ui';

import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/auth/Signup/src/textfield.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:exotic/data/theme/app_theme.dart';
import 'package:exotic/view/auth/Signin/subscreens/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninComponent extends StatefulWidget {
  const SigninComponent({super.key});

  @override
  State<SigninComponent> createState() => _SigninComponentState();
}

class _SigninComponentState extends State<SigninComponent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _email.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<UserLoginProvider>().email = _email.text.trim();
    context.push('/dynamicRoute', extra: () => PasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Blob background ───────────────────────────────────────────────
          Image.asset(
            'assets/src/login_blob.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
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

          // ── Main content ──────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: t.spaceXXL),
                child: SlideTransition(
                  position: _slideAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ── Glassmorphism card ───────────────────────
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
                                    color: Colors.white.withValues(alpha: 0.55),
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
                                      // ── Icon badge ────────────────────
                                      Container(
                                        padding: EdgeInsets.all(t.spaceXL - 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: t.brandPrimary.withValues(
                                                alpha: 0.2,
                                              ),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.mail_outline_rounded,
                                          size: 42,
                                          color: t.brandPrimary,
                                        ),
                                      ),

                                      SizedBox(height: t.spaceXXL),

                                      // ── Headline ──────────────────────
                                      Text(
                                        'Welcome Back 👋',
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
                                        'Enter your email to continue',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: Colors.black54,
                                              height: 1.5,
                                            ),
                                      ),

                                      SizedBox(height: t.spaceXXL + 4),

                                      // ── Email field ───────────────────
                                      AuthTextField(
                                        hint: 'you@example.com',
                                        label: 'Email address',
                                        prefixIcon: Icons.mail_outline_rounded,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        controller: _email,
                                        onFieldSubmitted: (_) => _onSubmit(),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          if (!RegExp(
                                            r'^[^@]+@[^@]+\.[^@]+',
                                          ).hasMatch(value)) {
                                            return 'Enter a valid email address';
                                          }
                                          return null;
                                        },
                                      ),

                                      SizedBox(height: t.spaceLG),

                                      // ── Submit ────────────────────────
                                      AuthPrimaryButton(
                                        label: 'Next →',
                                        isLoading: _isLoading,
                                        onPressed: _onSubmit,
                                      ),

                                      SizedBox(height: t.spaceLG),

                                      // ── Links row ────────────────────
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () => context.pop(),
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
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black54,
                                                  ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => context.push(
                                                  '/dynamicRoute',
                                                  extra: () => PasswordScreen(),
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
                                              'New here? Sign up',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
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

                            // ── Legal text below card ────────────────────────
                            Text(
                              'By continuing, you agree to our Terms & Privacy Policy',
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
          ),
        ],
      ),
    );
  }
}
