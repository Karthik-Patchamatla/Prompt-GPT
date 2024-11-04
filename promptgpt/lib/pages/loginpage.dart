import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:promptgpt/components/my_button.dart';
import 'package:promptgpt/components/textfield.dart';
import 'package:promptgpt/pages/forgotpassword.dart';
import 'package:promptgpt/pages/registerpage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginPage({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

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
                Image.asset('lib/images/gptlogologo.png', height: 200.0),
                const SizedBox(height: 30.0),
                const Text(
                  "Welcome back, you've been missed",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                _LoginForm(
                  usernameController: usernameController,
                  passwordController: passwordController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const _LoginForm({
    required this.usernameController,
    required this.passwordController,
  });

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm>
    with AutomaticKeepAliveClientMixin {
  String? errorMessage;
  bool isLoading = false;

  late FocusNode usernameFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    usernameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    final email = widget.usernameController.text.trim();
    final password = widget.passwordController.text.trim();

    // Basic email validation
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      setState(() => errorMessage = "Please enter a valid email address.");
      return;
    }

    if (password.length < 6) {
      setState(
          () => errorMessage = "Password must be at least 6 characters long.");
      return;
    }

    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() => errorMessage = null);
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() =>
          errorMessage = e.message ?? "An error occurred. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 15.0),
        CustomTextWidget(
          controller: widget.usernameController,
          hintText: 'Email',
          obscureText: false,
          focusNode: usernameFocusNode,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
        ),
        const SizedBox(height: 15.0),
        CustomTextWidget(
          controller: widget.passwordController,
          hintText: 'Password',
          obscureText: true,
          focusNode: passwordFocusNode,
          onFieldSubmitted: (_) {
            signIn();
          },
        ),
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                margin: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25.0),
        isLoading
            ? const CircularProgressIndicator()
            : MyButton(onTap: signIn, text: 'Sign In'),
        const SizedBox(height: 25.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an Account? ",
                style: TextStyle(color: Colors.white)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(
                      emailController: widget.usernameController,
                      passwordController: widget.passwordController,
                      confirmPasswordController: TextEditingController(),
                    ),
                  ),
                );
              },
              child: const Text(
                'Register Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
