import 'package:flutter/material.dart';

Widget buildRoundedTextField({
  required String hint,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  required TextEditingController controller,
  required String? Function(String?)? validator, // <-- added
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      width: 335,
      height: 60,
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator, // <-- used here
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 13.83,
            fontWeight: FontWeight.w500,
          ),

          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Color(0xFF9747FF)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    ),
  );
}
