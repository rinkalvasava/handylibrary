import 'package:flutter/material.dart';
import 'package:handy_library/email__verification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "custom_widgets/custom_text_field.dart";

class CollegeSignupPage extends StatefulWidget {
  const CollegeSignupPage(
      {super.key, required TextEditingController collegeNameController});

  @override
  _CollegeSignupPageState createState() => _CollegeSignupPageState();
}

class _CollegeSignupPageState extends State<CollegeSignupPage> {
  final TextEditingController collegeNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> universities = [];
  String? selectedUniversityId;

  @override
  void initState() {
    super.initState();
    fetchUniversities();
  }

  /// Fetch universities from the backend
  Future<void> fetchUniversities() async {
    try {
      final response =
          await http.get(Uri.parse("http://localhost/HL/get_universities.php"));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          universities = List<Map<String, String>>.from(
            jsonData.map((uni) => {
                  "id": uni["university_id"].toString(),
                  "name": uni["university_name"].toString(),
                }),
          );
        });
      } else {
        print("Error: HTTP ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching universities: $e");
    }
  }

  /// Submit the registration form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> requestBody = {
        "college_name": collegeNameController.text,
        "username": usernameController.text,
        "email": emailController.text,
        "contact_no": contactNumberController.text,
        "location": locationController.text,
        "password": passwordController.text,
        "university_id": selectedUniversityId,
      };

      try {
        final response = await http.post(
          Uri.parse("http://localhost/HL/college_reg.php"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        print("Response Status: ${response.statusCode}");
        print("Raw Response Body: ${response.body}");

        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          final responseData = jsonDecode(response.body);

          if (responseData["status"] == "success") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EmailVerificationScreen(email: emailController.text),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text("Registration failed: ${responseData["message"]}")),
            );
          }
        } else {
          print("Error: Server returned non-JSON response.");
        }
      } catch (e) {
        print("Error submitting form: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("College Signup")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: collegeNameController,
                  label: "College Name",
                  obscureText: false,
                  textColor: Colors.black,
                ),
                CustomTextField(
                  controller: emailController,
                  label: "Email",
                  obscureText: false,
                  textColor: Colors.black,
                ),
                CustomTextField(
                  controller: contactNumberController,
                  label: "Contact Number",
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  textColor: Colors.black,
                ),
                CustomTextField(
                  controller: locationController,
                  label: "Location",
                  obscureText: false,
                  textColor: Colors.black,
                ),
                CustomTextField(
                  controller: usernameController,
                  label: "Username",
                  obscureText: false,
                  textColor: Colors.black,
                ),
                CustomTextField(
                  controller: passwordController,
                  label: "Password",
                  obscureText: true,
                  textColor: Colors.black,
                ),
                CustomTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  obscureText: true,
                  textColor: Colors.black,
                ),
                const SizedBox(height: 20),

                // University Dropdown
                DropdownButtonFormField<String>(
                  value: selectedUniversityId,
                  items: universities.map((uni) {
                    return DropdownMenuItem<String>(
                      value: uni["id"],
                      child: Text(uni["name"]!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUniversityId = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "Select University",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value == null ? "Please select a university" : null,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _submitForm, child: const Text("Sign Up")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
