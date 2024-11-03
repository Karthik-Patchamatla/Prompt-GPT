import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:promptgpt/components/my_button.dart';
import 'package:promptgpt/components/textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String? statusMessage;

  // Function to send a password reset email
  Future<void> sendPasswordResetEmail() async {
    setState(() {
      isLoading = true;
      statusMessage = null;
    });
    try {
      String email = emailController.text.trim();
      print("Attempting to send password reset email to: $email");

      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        statusMessage = "If the email exists, a password reset link has been sent.";
      });
      print("Password reset email sent successfully.");
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
      setState(() {
        statusMessage = e.message ?? "An error occurred. Please try again.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/images/pgptlogo.png', height: 200.0),
                const SizedBox(height: 30.0),
                const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                if (statusMessage != null)
                  Text(
                    statusMessage!,
                    style: TextStyle(
                      color: statusMessage!.contains("error") ? Colors.red : Colors.green,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 15.0),
                CustomTextWidget(
                  controller: emailController,
                  hintText: 'Enter your email',
                  obscureText: false,
                ),
                const SizedBox(height: 20.0),
                if (isLoading) const CircularProgressIndicator(),
                if (!isLoading)
                  MyButton(
                    onTap: sendPasswordResetEmail,
                    text: 'Send Password Reset Link',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
