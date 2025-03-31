import 'package:flutter/material.dart';
import 'package:handy_library/components/constants.dart';
import 'package:handy_library/components/input_container.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput(
      {super.key,
      required this.icon,
      required this.hint,
      required TextEditingController controller,
      required Null Function(dynamic value) onChanged,
      required String? Function(dynamic value) validator});

  final IconData icon;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
          icon: Icon(icon, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none),
    ));
  }
}
