import 'package:flutter/material.dart';
import 'package:handy_library/signup.dart';
import 'package:handy_library/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(6, 49, 106, 1), // Deep blue
                  Color.fromRGBO(108, 185, 206, 0.9), // Light blue
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      _buildTitle(screenWidth), // **Scalable Text**
                      SizedBox(height: screenHeight * 0.04),
                      _buildImage(
                          screenWidth, screenHeight), // **Scalable Image**
                      SizedBox(height: screenHeight * 0.05),
                      _buildButton(
                        context,
                        'Sign up',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()),
                          );
                        },
                        screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildButton(
                        context,
                        'Sign in',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// **Title Text Widget (Responsive)**
  Widget _buildTitle(double screenWidth) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        'Welcome \n to \n Handy Library',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.08, // **Scales proportionally**
          fontFamily: 'Bacasime Antique',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// **Logo Image Widget (Responsive)**
  Widget _buildImage(double screenWidth, double screenHeight) {
    return FractionallySizedBox(
      widthFactor: 0.7, // **Adapts to different screen widths**
      child: Image.asset(
        'assets/images/logo.png',
        height: screenHeight * 0.3, // **Ensures it scales well**
        fit: BoxFit.contain,
      ),
    );
  }

  /// **Reusable Button Widget (Responsive)**
  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed,
      double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.7, // **Responsive width**
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 13, 156, 218),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          ),
          padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.035), // **Ensures good tap area**
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.05, // **Scales for different screens**
              fontFamily: 'Bacasime Antique',
            ),
          ),
        ),
      ),
    );
  }
}
