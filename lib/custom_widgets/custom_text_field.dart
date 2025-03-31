import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? icon; // Optional icon
  final TextEditingController controller;
  final String? Function(String?)? validator; // Validation function
  final Widget? suffixIcon; // Make it nullable

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText = '',
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.icon,
    required this.controller,
    this.validator,
    this.suffixIcon,
    required bool obscureText,
    required Color textColor, // Now nullable
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: icon != null
              ? Icon(icon, color: const Color(0xFF1034A6))
              : null, // Only add prefix icon if icon is not null
          suffixIcon: suffixIcon, // Allow optional suffix icon
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 26, 69, 156), width: 3.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
