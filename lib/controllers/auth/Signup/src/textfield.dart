import 'package:flutter/material.dart';
import 'package:exotic/data/theme/app_theme.dart';

/// A reusable branded text field used across all auth screens.
/// Replaces the old fixed-width buildRoundedTextField() function.
class AuthTextField extends StatelessWidget {
  final String hint;
  final String? label;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  const AuthTextField({
    super.key,
    required this.hint,
    this.label,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: t.spaceMD),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction ?? TextInputAction.next,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label ?? hint,
          hintText: hint,
          hintStyle: theme.textTheme.bodySmall?.copyWith(color: Colors.black38),
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black45,
          ),
          floatingLabelStyle: TextStyle(
            color: t.brandPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          prefixIcon: Icon(prefixIcon, size: 20, color: Colors.black38),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color(0xFFF8F7FF),
          contentPadding: EdgeInsets.symmetric(
            horizontal: t.spaceLG,
            vertical: t.spaceLG,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(t.radiusMD),
            borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(t.radiusMD),
            borderSide: BorderSide(color: t.brandPrimary, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(t.radiusMD),
            borderSide: BorderSide(color: t.brandPink, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(t.radiusMD),
            borderSide: BorderSide(color: t.brandPink, width: 1.8),
          ),
          errorStyle: theme.textTheme.labelSmall?.copyWith(color: t.brandPink),
        ),
      ),
    );
  }
}

/// Primary brand-coloured submit button shared across auth screens.
class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.brandPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: t.brandPrimary.withValues(alpha: 0.5),
          elevation: 0,
          shadowColor: t.brandPrimary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.radiusMD),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child:
            isLoading
                ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                : Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
      ),
    );
  }
}
