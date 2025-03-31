import 'package:flutter/material.dart';
import 'university_signup.dart';
import 'college_signup.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController universityNameController =
      TextEditingController();
  final TextEditingController collegeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UniversitySignupPage(
                          universityNameController: universityNameController,
                        ),
                      ),
                    );
                  },
                  child: const Text('University Signup'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollegeSignupPage(
                          collegeNameController: collegeNameController,
                        ),
                      ),
                    );
                  },
                  child: const Text('College Signup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
