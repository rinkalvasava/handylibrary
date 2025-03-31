import 'package:flutter/material.dart';
import 'package:handy_library/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const WelcomeScreen(), // Navigate to welcome screen
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovered = true; // Change hover state
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovered = false; // Reset hover state
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: screenWidth *
                    0.3, // Adjust width dynamically based on screen size
                height: screenWidth *
                    0.3, // Adjust height dynamically based on screen size
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                  color: Colors.transparent, // Transparent background
                  border: Border.all(
                    color: _isHovered
                        ? Colors.orangeAccent // Fire-like color on hover
                        : Colors.white, // Default white color when not hovered
                    width: 8, // Border width
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_stories, // Library icon
                    size: 80, // Icon size
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
                height: screenHeight *
                    0.02), // Dynamic spacing based on screen height
            Text(
              "Handy Library",
              style: TextStyle(
                fontSize: screenWidth *
                    0.08, // Adjust font size dynamically based on screen width
                fontWeight: FontWeight.w400,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
