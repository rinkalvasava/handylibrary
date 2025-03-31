import 'package:flutter/material.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 14, 86, 148),
      child: Center( // Wrap Column with Center widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            const Text(
              "Handy Library",
              textAlign: TextAlign.center, // Center text
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Inter',
                color: Colors.white,
              ),
            ),
            Image.asset('assets/images/intro2.png'),
            const Text(
              "Degree based Materials",
              textAlign: TextAlign.center, // Center text
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0), // Add padding for better readability
              child: Text(
                "Learning the structure/property relationships of materials",
                textAlign: TextAlign.center, // Center text
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
