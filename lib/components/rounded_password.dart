import 'package:flutter/material.dart';
import 'package:handy_library/components/input_container.dart';
import 'package:handy_library/components/constants.dart';

class RoundedPassword extends StatelessWidget {
  const RoundedPassword(
      {super.key,
      required this.hint,
      required IconData icon,
      required TextEditingController controller,
      required Null Function(dynamic value) onChanged,
      required String? Function(dynamic value) validator});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
      cursorColor: kPrimaryColor,
      obscureText: true,
      decoration: InputDecoration(
          icon: const Icon(Icons.lock, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none),
    ));
  }
}
