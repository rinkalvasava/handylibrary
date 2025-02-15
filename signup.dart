import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'custom_widgets/custom_text_field.dart';
import 'subscription.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isUniversitySelected = true;

  // Controllers for university and college signups

  final TextEditingController uniName = TextEditingController();
  final TextEditingController uniEmail = TextEditingController();
  final TextEditingController uniUsername = TextEditingController();
  final TextEditingController uniLocation = TextEditingController();
  final TextEditingController uniPassword = TextEditingController();
  final TextEditingController uniConPassword = TextEditingController();
  final TextEditingController clgName = TextEditingController();
  final TextEditingController clgEmail = TextEditingController();
  final TextEditingController clgUsername = TextEditingController();
  final TextEditingController clgLocation = TextEditingController();
  final TextEditingController clgPassword = TextEditingController();
  final TextEditingController clgConPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Bacasime Antique',
                    color: Color.fromARGB(255, 7, 76, 204),
                  ),
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/welcome.png',
                  width: 150,
                  height: 150,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => isUniversitySelected = true),
                  child: const Text('University'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => setState(() => isUniversitySelected = false),
                  child: const Text('College'),
                ),
              ],
            ),
            Expanded(
              child: isUniversitySelected
                  ? UniversitySignupForm(
                      uniName: uniName,
                      uniEmail: uniEmail,
                      uniUsername: uniUsername,
                      uniLocation: uniLocation,
                      uniPassword: uniPassword,
                      uniConPassword: uniConPassword,
                    )
                  : CollegeSignupForm(
                      clgName: clgName,
                      clgEmail: clgEmail,
                      clgUsername: clgUsername,
                      clgLocation: clgLocation,
                      clgPassword: clgPassword,
                      clgConPassword: clgConPassword,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class UniversitySignupForm extends StatefulWidget {
  const UniversitySignupForm({
    super.key,
    required this.uniName,
    required this.uniEmail,
    required this.uniUsername,
    required this.uniLocation,
    required this.uniPassword,
    required this.uniConPassword,
  });

  final TextEditingController uniName;
  final TextEditingController uniEmail;
  final TextEditingController uniUsername;
  final TextEditingController uniLocation;
  final TextEditingController uniPassword;
  final TextEditingController uniConPassword;

  @override
  _UniversitySignupFormState createState() => _UniversitySignupFormState();
}

class _UniversitySignupFormState extends State<UniversitySignupForm> {
  final _formKey = GlobalKey<FormState>();
  final String phpUrl = 'http://192.168.29.114/api/register.php';

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final formData = {
      'uni_name': widget.uniName.text,
      'uni_email': widget.uniEmail.text,
      'uni_username': widget.uniUsername.text,
      'uni_location': widget.uniLocation.text,
      'uni_password': widget.uniPassword.text,
    };

    try {
      final response = await http.post(
        Uri.parse(phpUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData,
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubscriptionPage()),
          );
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting form: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          CustomTextField(
            controller: widget.uniName,
            hintText: "University Name",
            label: "University Name",
            obscureText: true,
          ),
          CustomTextField(
            controller: widget.uniEmail,
            hintText: "University Email",
            label: "University Email",
            obscureText: true,
          ),
          CustomTextField(
            controller: widget.uniUsername,
            hintText: "Username",
            label: "Username",
            obscureText: true,
          ),
          CustomTextField(
            controller: widget.uniLocation,
            hintText: "Location",
            label: "Location",
            obscureText: true,
          ),
          CustomTextField(
              controller: widget.uniPassword,
              hintText: "Password",
              obscureText: true,
              label: "Password"),
          CustomTextField(
              controller: widget.uniConPassword,
              hintText: "Confirm Password",
              obscureText: true,
              label: "Confirm Password"),
          ElevatedButton(onPressed: submitForm, child: const Text("Sign Up")),
        ],
      ),
    );
  }
}

class CollegeSignupForm extends StatelessWidget {
  const CollegeSignupForm({
    super.key,
    required this.clgName,
    required this.clgEmail,
    required this.clgUsername,
    required this.clgLocation,
    required this.clgPassword,
    required this.clgConPassword,
  });

  final TextEditingController clgName;
  final TextEditingController clgEmail;
  final TextEditingController clgUsername;
  final TextEditingController clgLocation;
  final TextEditingController clgPassword;
  final TextEditingController clgConPassword;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        CustomTextField(
          controller: clgName,
          hintText: "College Name",
          label: "College Name",
          obscureText: true,
        ),
        CustomTextField(
          controller: clgEmail,
          hintText: "College Email",
          label: "College Email",
          obscureText: true,
        ),
        CustomTextField(
          controller: clgUsername,
          hintText: "Username",
          label: "Username",
          obscureText: true,
        ),
        CustomTextField(
          controller: clgLocation,
          hintText: "Location",
          label: "Location",
          obscureText: true,
        ),
        CustomTextField(
            controller: clgPassword,
            hintText: "Password",
            obscureText: true,
            label: "Password"),
        CustomTextField(
            controller: clgConPassword,
            hintText: "Confirm Password",
            obscureText: true,
            label: "Confirm Password"),
      ],
    );
  }
}
