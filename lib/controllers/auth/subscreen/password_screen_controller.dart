import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/auth/Signup/src/textfield.dart';
import 'package:exotic/controllers/auth/src/alertDailog.dart';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/models/user.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/data/theme/app_theme.dart';
import 'package:exotic/view/auth/forgotPassword/SmsSendingScreen.dart';
import 'package:exotic/view/auth/forgotPassword/forgotPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordScreenComponent extends StatefulWidget {
  const PasswordScreenComponent({super.key});

  @override
  State<PasswordScreenComponent> createState() =>
      _PasswordScreenComponentState();
}

class _PasswordScreenComponentState extends State<PasswordScreenComponent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final password = _controller.text.trim();
    if (password.isEmpty) {
      showCustomAlertBox(
        context: context,
        type: AlertType.error,
        errors: ['Please fill in the password field'],
        message: 'Password cannot be empty',
        onOkay: () => context.pop(),
      );
      return;
    }

    setState(() => _isLoading = true);
    context.read<UserLoginProvider>().password = password;
    context.read<AuthBloc>().add(
          SigninEvent(
            email: context.read<UserLoginProvider>().email,
            password: password,
            mobileNo: context.read<UserLoginProvider>().mobileno,
          ),
        );
  }

  void _onCancel() => context.pop();

  void _onForgotPassword() =>
      context.push('/dynamicRoute', extra: () => ForgotpasswordScreen());

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);
    final username = context.read<UserLoginProvider>().username;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          setState(() => _isLoading = true);
        }

        if (state is AuthSigninSuccessState) {
          setState(() => _isLoading = false);
          context.read<UserProvider>().setUser(
                User.fromJson(state.data['user']),
              );
          final email = context.read<UserProvider>().user!.email;
          final mobileno = context.read<UserProvider>().user!.phone;

          // Persist login so the user stays signed in across restarts
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('email', context.read<UserLoginProvider>().email);
            prefs.setString(
                'password', context.read<UserLoginProvider>().password);
          });

          context.read<AuthBloc>().add(
                AuthOTPSentInternalEvent(email: email, mobileno: mobileno),
              );
          context.push('/dynamicRoute', extra: () => SmsSendingScreen());
        }

        if (state is AuthOTPSentState) {
          setState(() => _isLoading = false);
        }

        if (state is AuthErrorState) {
          setState(() => _isLoading = false);
          showCustomAlertBox(
            context: context,
            message: state.message,
            errors: state.errors,
            onOkay: () => context.pop(),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Blob background ─────────────────────────────────────────────
            Image.asset(
              'assets/src/login_blob_2.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              alignment: AlignmentDirectional.topStart,
              errorBuilder: (_, __, ___) => Container(
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

            // ── Content ──────────────────────────────────────────────────────
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
                            // ── Glassmorphism card ─────────────────────────
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(t.radiusLG + 8),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.55),
                                    borderRadius:
                                        BorderRadius.circular(t.radiusLG + 8),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.6),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.06),
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
                                      // ── Avatar badge ──────────────────
                                      Container(
                                        padding:
                                            EdgeInsets.all(t.spaceXL - 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.8),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: t.brandPrimary
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.lock_outline_rounded,
                                          size: 42,
                                          color: t.brandPrimary,
                                        ),
                                      ),

                                      SizedBox(height: t.spaceXXL),

                                      // ── Greeting ──────────────────────
                                      Text(
                                        username.isNotEmpty
                                            ? 'Hello, $username! 👋'
                                            : 'Welcome back! 👋',
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
                                        'Enter your password to continue',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: Colors.black54,
                                          height: 1.5,
                                        ),
                                      ),

                                      SizedBox(height: t.spaceXXL + 4),

                                      // ── Password field ─────────────────
                                      AuthTextField(
                                        hint: 'Enter your password',
                                        label: 'Password',
                                        prefixIcon: Icons.lock_outline_rounded,
                                        obscureText: _obscureText,
                                        controller: _controller,
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (_) => _onSubmit(),
                                        suffixIcon: _isLoading
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      t.brandPrimary,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  _obscureText
                                                      ? Icons
                                                          .visibility_off_outlined
                                                      : Icons
                                                          .visibility_outlined,
                                                  color: Colors.black38,
                                                  size: 20,
                                                ),
                                                onPressed: () => setState(
                                                  () => _obscureText =
                                                      !_obscureText,
                                                ),
                                              ),
                                        validator: (v) =>
                                            (v == null || v.isEmpty)
                                                ? 'Please enter your password'
                                                : null,
                                      ),

                                      SizedBox(height: t.spaceLG),

                                      // ── Login button ──────────────────
                                      AuthPrimaryButton(
                                        label: 'Login',
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
                                            onPressed: _onCancel,
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.black54,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        t.radiusSM),
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
                                            onPressed: _onForgotPassword,
                                            style: TextButton.styleFrom(
                                              foregroundColor: t.brandPrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        t.radiusSM),
                                              ),
                                            ),
                                            child: Text(
                                              'Forgot password?',
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

                            // ── Legal text ────────────────────────────────
                            Text(
                              'Your data is protected with end-to-end encryption',
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
    );
  }
}
