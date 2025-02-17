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
  final TextEditingController Email = TextEditingController();
  final TextEditingController Username = TextEditingController();
  final TextEditingController Location = TextEditingController();
  final TextEditingController Password = TextEditingController();
  final TextEditingController ConPassword = TextEditingController();
  final TextEditingController Name = TextEditingController();
  final TextEditingController Email = TextEditingController();
  final TextEditingController Username = TextEditingController();
  final TextEditingController Location = TextEditingController();
  final TextEditingController Password = TextEditingController();
  final TextEditingController ConPassword = TextEditingController();

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
                      Email: Email,
                      Username: Username,
                      Location: Location,
                      Password: Password,
                      ConPassword: ConPassword,
                    )
                  : CollegeSignupForm(
                      Name: Name,
                      Email: Email,
                      Username: Username,
                      Location: Location,
                      Password: Password,
                      ConPassword: ConPassword,
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
    required this.Email,
    required this.Username,
    required this.Location,
    required this.Password,
    required this.ConPassword,
  });

  final TextEditingController uniName;
  final TextEditingController Email;
  final TextEditingController Username;
  final TextEditingController Location;
  final TextEditingController Password;
  final TextEditingController ConPassword;

  @override
  _UniversitySignupFormState createState() => _UniversitySignupFormState();
}

class _UniversitySignupFormState extends State<UniversitySignupForm> {
  final _formKey = GlobalKey<FormState>();
  final String phpUrl = 'http://192.168.64.58/flutter/api/register.php';

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final formData = {
      'uni_name': widget.uniName.text,
      'email': widget.Email.text,
      'username': widget.Username.text,
      'location': widget.Location.text,
      'password': widget.Password.text,
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
            controller: widget.Username,
            hintText: "Username",
            label: "Username",
            obscureText: true,
          ),
          CustomTextField(
            controller: widget.Location,
            hintText: "Location",
            label: "Location",
            obscureText: true,
          ),
          CustomTextField(
              controller: widget.Password,
              hintText: "Password",
              obscureText: true,
              label: "Password"),
          CustomTextField(
              controller: widget.ConPassword,
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
    required this.Name,
    required this.Email,
    required this.Username,
    required this.Location,
    required this.Password,
    required this.ConPassword,
  });

  final TextEditingController Name;
  final TextEditingController Email;
  final TextEditingController Username;
  final TextEditingController Location;
  final TextEditingController Password;
  final TextEditingController ConPassword;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        CustomTextField(
          controller: Name,
          hintText: "College Name",
          label: "College Name",
          obscureText: true,
        ),
        CustomTextField(
          controller: Email,
          hintText: "College Email",
          label: "College Email",
          obscureText: true,
        ),
        CustomTextField(
          controller: Username,
          hintText: "Username",
          label: "Username",
          obscureText: true,
        ),
        CustomTextField(
          controller: Location,
          hintText: "Location",
          label: "Location",
          obscureText: true,
        ),
        CustomTextField(
            controller: Password,
            hintText: "Password",
            obscureText: true,
            label: "Password"),
        CustomTextField(
            controller: ConPassword,
            hintText: "Confirm Password",
            obscureText: true,
            label: "Confirm Password"),
      ],
    );
  }
}
