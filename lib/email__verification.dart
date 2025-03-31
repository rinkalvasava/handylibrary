import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:handy_library/subscription.dart';
import 'package:http/http.dart' as http;

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isOtpSent = false;
  bool isOtpExpired = false;
  String timerText = "01:00";
  Timer? _timer;
  int _remainingTime = 60;

  final _otpFocusNode = FocusNode();

  @override
  void dispose() {
    _otpFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _remainingTime = 60;
    isOtpExpired = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
          final minutes = _remainingTime ~/ 60;
          final seconds = _remainingTime % 60;
          timerText =
              "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
        });
      } else {
        setState(() {
          timerText = "Expired";
          isOtpExpired = true;
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> requestOtp() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost/HL/request_otp.php"),
        body: {"email": widget.email},
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        setState(() {
          isOtpSent = true;
          isOtpExpired = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"])),
        );
        startTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData["message"] ?? "Failed to send OTP.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  Future<void> verifyOtp() async {
    if (isOtpExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("OTP has expired. Please request a new OTP.")),
      );
      return;
    }

    final otp = _otpController.text;
    try {
      final response = await http.post(
        Uri.parse("http://localhost/HL/verify_otp.php"),
        body: {"email": widget.email, "otp": otp},
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("OTP Verified! Navigating to Home Page...")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SubscriptionPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"] ?? "Invalid OTP.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    requestOtp();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: screenHeight * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.14),
              Text(
                'Verify Email',
                style: TextStyle(
                  fontSize: isMobile ? 40 : 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bacasime Antique',
                  color: const Color.fromARGB(255, 7, 76, 204),
                ),
              ),
              Image.asset(
                'assets/images/email logo.png',
                width: screenWidth * 0.6,
                height: screenHeight * 0.20,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("OTP sent to: ${widget.email}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black)),
                      SizedBox(height: screenHeight * 0.02),
                      Text("OTP Valid for: $timerText",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red)),
                      TextFormField(
                        controller: _otpController,
                        focusNode: _otpFocusNode,
                        decoration: InputDecoration(
                          hintText: "Enter OTP",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? "Please enter OTP"
                            : null,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ElevatedButton(
                        onPressed: verifyOtp,
                        style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(screenWidth * 0.8, screenHeight * 0.06)),
                        child: const Text("Verify OTP",
                            style: TextStyle(fontSize: 18)),
                      ),
                      if (isOtpExpired) ...[
                        SizedBox(height: screenHeight * 0.02),
                        TextButton(
                            onPressed: requestOtp,
                            child: const Text("Resend OTP")),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
