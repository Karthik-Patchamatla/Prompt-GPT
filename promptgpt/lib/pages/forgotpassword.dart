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
  final TextEditingController newPasswordController = TextEditingController();
  bool emailFound = false;
  bool isLoading = false;
  String? errorMessage;

  Future<void> checkEmailAndShowPasswordField() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      // Remove extra spaces from the email
      String email = emailController.text.trim();

      // Fetch sign-in methods
      List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        // Email exists
        setState(() {
          emailFound = true;
          errorMessage = null;
        });
      } else {
        // No methods found, meaning email does not exist
        setState(() {
          emailFound = false;
          errorMessage = "No email found in Firebase.";
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "An error occurred. Please try again.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> changePassword() async {
    setState(() => isLoading = true);
    try {
      // Re-authenticate user if necessary
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(newPasswordController.text.trim());
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: const Text("Password changed successfully."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          errorMessage = "User session expired. Please log in again.";
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? "Failed to change password.");
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
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 15.0),
                CustomTextWidget(
                  controller: emailController,
                  hintText: 'Enter your email',
                  obscureText: false,
                  onFieldSubmitted: (_) {
                    checkEmailAndShowPasswordField();
                  },
                ),
                const SizedBox(height: 20.0),
                if (isLoading) const CircularProgressIndicator(),
                if (!emailFound && !isLoading)
                  MyButton(
                    onTap: checkEmailAndShowPasswordField,
                    text: 'Check Email',
                  ),
                if (emailFound)
                  Column(
                    children: [
                      const SizedBox(height: 15.0),
                      CustomTextWidget(
                        controller: newPasswordController,
                        hintText: 'New Password',
                        obscureText: true,
                        onFieldSubmitted: (_) {
                          changePassword();
                        },
                      ),
                      const SizedBox(height: 25.0),
                      MyButton(
                        onTap: changePassword,
                        text: 'Change Password',
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
