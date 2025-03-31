import 'package:flutter/material.dart';

class CenterOfLibraryPage extends StatelessWidget {
  const CenterOfLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Center of Library Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
