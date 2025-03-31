import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? icon; // Optional icon
  final TextEditingController controller;
  final String? Function(String?)? validator; // Add validator for validation

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText = '',
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.icon, // Icon parameter
    required this.controller,
    this.validator,
    required bool obscureText,
    required Color textColor, // Validator parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        // Use TextFormField instead of TextField to apply validation
        controller: controller, // Set the controller here
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator, // Apply the validator
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon, color: const Color(0xFF1034A6)),
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
