import 'package:flutter/material.dart';
import 'package:handy_library/admin/dashboard.dart';
import 'package:handy_library/screens/onBoarding_screens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: unused_import
import 'home.dart';
import 'custom_widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> authenticateUser(BuildContext context) async {
    const String loginUrl = 'http://localhost/HL/login.php';

    if (username.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both username and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (username.text.trim() == 'admin' &&
        password.text.trim() == 'admin@123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LibraryDashboard()),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': username.text.trim(),
          'password': password.text.trim(),
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OnBoardingScreen(username: username.text.trim())),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Invalid credentials'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Server error: ${response.statusCode}\n${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.05,
              vertical: constraints.maxHeight * 0.02,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/login_logo.png',
                      width: constraints.maxWidth * 0.6,
                      height: constraints.maxHeight * 0.3,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: constraints.maxWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Bacasime Antique',
                        color: const Color.fromARGB(255, 7, 76, 204),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: constraints.maxWidth * 0.8,
                      child: Column(
                        children: [
                          CustomTextField(
                            label: "Username",
                            controller: username,
                            icon: Icons.person,
                            keyboardType: TextInputType.name,
                            obscureText: false,
                            textColor: Colors.black,
                          ),
                          CustomTextField(
                            label: "Password",
                            controller: password,
                            icon: Icons.lock,
                            keyboardType: TextInputType.text,
                            isPassword: true,
                            obscureText: true,
                            textColor: Colors.black,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.03),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1034A6),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: constraints.maxHeight * 0.02,
                                horizontal: constraints.maxWidth * 0.2,
                              ),
                              textStyle: TextStyle(
                                fontSize: constraints.maxWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () => authenticateUser(context),
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
