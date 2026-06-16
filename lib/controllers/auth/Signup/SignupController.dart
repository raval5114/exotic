import 'package:go_router/go_router.dart';
import 'dart:io';

import 'package:exotic/controllers/auth/Signup/src/textfield.dart';
import 'package:exotic/controllers/auth/src/alertDailog.dart';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SignupController extends StatefulWidget {
  const SignupController({super.key});

  @override
  State<SignupController> createState() => _SignupControllerState();
}

class _SignupControllerState extends State<SignupController>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _firstname.dispose();
    _lastname.dispose();
    _username.dispose();
    _email.dispose();
    _mobileNumber.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  void onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          SignupEvent(
            firstName: _firstname.text.trim(),
            lastName: _lastname.text.trim(),
            profilePhoto: _selectedImage!,
            username: _username.text.trim(),
            email: _email.text.trim(),
            mobileNumber: _mobileNumber.text.trim(),
            password: _password.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          setState(() => _isLoading = true);
        }
        if (state is AuthSignupSuccessState) {
          setState(() => _isLoading = false);
          showCustomAlertBox(
            context: context,
            message: 'Account created successfully!',
            errors: [],
            type: AlertType.success,
            onOkay: () {
              context.pop();
              context.pop();
            },
          );
        }
        if (state is AuthErrorState) {
          setState(() => _isLoading = false);
          showCustomAlertBox(
            context: context,
            message: state.message,
            errors: state.errors,
            type: AlertType.error,
            onOkay: () => context.pop(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F7FF),
          body: Stack(
            children: [
              // ── Header gradient strip ─────────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [t.brandPrimary, t.brandSecondary],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),

              // ── Decorative circle ────────────────────────────────────────
              Positioned(
                top: -60,
                right: -60,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),

              // ── Scrollable form ──────────────────────────────────────────
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        t.spaceXXL,
                        0,
                        t.spaceXXL,
                        MediaQuery.of(context).viewInsets.bottom + t.spaceXXL,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Top bar ───────────────────────────────────
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => context.pop(),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),

                            SizedBox(height: t.spaceXS),

                            Text(
                              'Create\nAccount ✨',
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: t.spaceXS),
                            Text(
                              'Join thousands of happy shoppers',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),

                            SizedBox(height: t.spaceXXL + 8),

                            // ── Form card ─────────────────────────────────
                            Container(
                              padding: EdgeInsets.all(t.spaceXXL),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(t.radiusLG + 4),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        t.brandPrimary.withValues(alpha: 0.07),
                                    blurRadius: 32,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Profile photo picker ────────────────
                                  Center(
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 88,
                                            height: 88,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  t.brandPrimary
                                                      .withValues(alpha: 0.15),
                                                  t.brandSecondary
                                                      .withValues(alpha: 0.1),
                                                ],
                                              ),
                                              border: Border.all(
                                                color: t.brandPrimary
                                                    .withValues(alpha: 0.3),
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: _selectedImage == null
                                                  ? Icon(
                                                      Icons
                                                          .person_outline_rounded,
                                                      size: 38,
                                                      color: t.brandPrimary,
                                                    )
                                                  : Image.file(
                                                      _selectedImage!,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              width: 26,
                                              height: 26,
                                              decoration: BoxDecoration(
                                                color: t.brandPrimary,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.add_a_photo_rounded,
                                                size: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: t.spaceXXL),

                                  // ── Section label ───────────────────────
                                  _SectionLabel(label: 'Personal Info'),
                                  SizedBox(height: t.spaceMD),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: AuthTextField(
                                          hint: 'John',
                                          label: 'First Name',
                                          prefixIcon:
                                              Icons.person_outline_rounded,
                                          controller: _firstname,
                                          validator: (v) =>
                                              (v == null || v.isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ),
                                      SizedBox(width: t.spaceMD),
                                      Expanded(
                                        child: AuthTextField(
                                          hint: 'Doe',
                                          label: 'Last Name',
                                          prefixIcon:
                                              Icons.person_outline_rounded,
                                          controller: _lastname,
                                          validator: (v) =>
                                              (v == null || v.isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ),
                                    ],
                                  ),

                                  AuthTextField(
                                    hint: '@username',
                                    label: 'Username',
                                    prefixIcon:
                                        Icons.alternate_email_rounded,
                                    controller: _username,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Please enter a username'
                                        : null,
                                  ),

                                  SizedBox(height: t.spaceSM),
                                  _SectionLabel(label: 'Contact Details'),
                                  SizedBox(height: t.spaceMD),

                                  AuthTextField(
                                    hint: 'you@example.com',
                                    label: 'Email',
                                    prefixIcon: Icons.mail_outline_rounded,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _email,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an email';
                                      }
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                          .hasMatch(value)) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),

                                  AuthTextField(
                                    hint: '10-digit mobile number',
                                    label: 'Phone Number',
                                    prefixIcon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    controller: _mobileNumber,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a mobile number';
                                      }
                                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                        return 'Enter a valid 10-digit number';
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: t.spaceSM),
                                  _SectionLabel(label: 'Security'),
                                  SizedBox(height: t.spaceMD),

                                  AuthTextField(
                                    hint: 'Min. 6 characters',
                                    label: 'Password',
                                    prefixIcon: Icons.lock_outline_rounded,
                                    obscureText: _obscurePassword,
                                    controller: _password,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.black38,
                                        size: 20,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),

                                  AuthTextField(
                                    hint: 'Re-enter password',
                                    label: 'Confirm Password',
                                    prefixIcon: Icons.lock_outline_rounded,
                                    obscureText: _obscureConfirmPassword,
                                    controller: _confirmPassword,
                                    textInputAction: TextInputAction.done,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.black38,
                                        size: 20,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscureConfirmPassword =
                                            !_obscureConfirmPassword,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _password.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: t.spaceXL),

                                  AuthPrimaryButton(
                                    label: 'Create Account',
                                    isLoading: _isLoading,
                                    onPressed: onSubmit,
                                  ),

                                  SizedBox(height: t.spaceMD),

                                  Center(
                                    child: TextButton(
                                      onPressed: () => context.pop(),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black45,
                                      ),
                                      child: Text(
                                        'Already have an account? Sign In',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: t.spaceLG),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Section label helper ─────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: t.brandPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: t.spaceXS),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: t.brandPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
        ),
      ],
    );
  }
}
