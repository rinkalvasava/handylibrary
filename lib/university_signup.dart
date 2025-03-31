import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:handy_library/email__verification.dart';
import 'package:http/http.dart' as http;
import 'custom_widgets/custom_text_field.dart';

class UniversitySignupPage extends StatefulWidget {
  const UniversitySignupPage(
      {super.key, required TextEditingController universityNameController});

  @override
  _UniversitySignupPageState createState() => _UniversitySignupPageState();
}

class _UniversitySignupPageState extends State<UniversitySignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController universityNameController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? selectedAccessId;
  String? selectedAccessPoint;
  List<Map<String, String>> accessPoints = [];

  @override
  void initState() {
    super.initState();
    _fetchAccessPoints();
  }

  // Fetch Access Points from Backend
  Future<void> _fetchAccessPoints() async {
    var url = Uri.parse("http://localhost/HL/get_access_point.php");

    try {
      var response = await http.get(url);
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data["status"] == "success" && data["access_point"] != null) {
          setState(() {
            accessPoints = List<Map<String, String>>.from(
              data["access_point"].map((point) => {
                    "access_id": point["access_id"].toString(),
                    "access_point": point["access_point"].toString(),
                  }),
            );
          });
        } else {
          throw Exception("Invalid access points data");
        }
      } else {
        throw Exception(
            "Failed to fetch data, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching access points")),
      );
    }
  }

  // Handle Form Submission
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }
      if (selectedAccessId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an access point")),
        );
        return;
      }

      // Find the selected access point name
      String selectedAccessPoint = accessPoints.firstWhere(
        (element) => element["access_id"] == selectedAccessId,
      )["access_point"]!;

      var url = Uri.parse("http://localhost/HL/university_reg.php");
      var body = jsonEncode({
        "university_name": universityNameController.text,
        "email": emailController.text,
        "contact_no": contactNumberController.text,
        "location": locationController.text,
        "username": usernameController.text,
        "password": passwordController.text,
        "access_id": selectedAccessId,
        "access_point": selectedAccessPoint, // Send Access Point Name
      });

      try {
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        var data = jsonDecode(response.body);

        if (data["status"] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"])),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EmailVerificationScreen(email: emailController.text),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration failed: ${data["message"]}")),
          );
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid response from server")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("University Signup")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                    controller: universityNameController,
                    label: "University Name",
                    obscureText: false,
                    textColor: Colors.black),
                CustomTextField(
                    controller: emailController,
                    label: "Email",
                    obscureText: false,
                    textColor: Colors.black),
                CustomTextField(
                    controller: contactNumberController,
                    label: "Contact Number",
                    obscureText: false,
                    textColor: Colors.black),
                CustomTextField(
                    controller: locationController,
                    label: "Location",
                    obscureText: false,
                    textColor: Colors.black),
                CustomTextField(
                    controller: usernameController,
                    label: "Username",
                    obscureText: false,
                    textColor: Colors.black),
                CustomTextField(
                    controller: passwordController,
                    label: "Password",
                    obscureText: true,
                    textColor: Colors.black),
                CustomTextField(
                    controller: confirmPasswordController,
                    label: "Confirm Password",
                    obscureText: true,
                    textColor: Colors.black),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedAccessId,
                  decoration: const InputDecoration(
                    labelText: "Access Point",
                    border: OutlineInputBorder(),
                  ),
                  items: accessPoints.isNotEmpty
                      ? accessPoints.map((Map<String, String> accessPoint) {
                          return DropdownMenuItem<String>(
                            value: accessPoint["access_id"],
                            child: Text(accessPoint["access_point"] ?? ""),
                          );
                        }).toList()
                      : [],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAccessId = newValue;
                      selectedAccessPoint = accessPoints.firstWhere(
                        (element) => element["access_id"] == newValue,
                      )["access_point"];
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select an access point" : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
