import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:promptgpt/components/my_button.dart';
import 'package:promptgpt/components/textfield.dart';

class RegisterPage extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterPage({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage;
  bool isLoading = false;

  Future<void> registerUser() async {
    if (widget.passwordController.text != widget.confirmPasswordController.text) {
      setState(() {
        errorMessage = "Passwords do not match!";
      });
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(widget.emailController.text.trim())) {
      setState(() {
        errorMessage = "Please enter a valid email address.";
      });
      return;
    }

    if (widget.passwordController.text.length < 6) {
      setState(() {
        errorMessage = "Password must be at least 6 characters long.";
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.emailController.text.trim(),
        password: widget.passwordController.text,
      );
      setState(() => errorMessage = null);
      Navigator.pop(context); 
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "An error occurred. Please try again.";
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
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/images/gptlogo.png', height: 200.0),
                const SizedBox(height: 30.0),
                const Text("Create an account", style: TextStyle(color: Colors.grey, fontSize: 16.0)),
                const SizedBox(height: 20.0),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 15.0),
                CustomTextWidget(
                  controller: widget.emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 15.0),
                CustomTextWidget(
                  controller: widget.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15.0),
                CustomTextWidget(
                  controller: widget.confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25.0),
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(onTap: registerUser, text: 'Register'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
