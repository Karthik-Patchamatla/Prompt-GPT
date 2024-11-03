import 'package:flutter/material.dart';
import 'auth_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Welcome to PromptGPT",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Text(
                "This official app is free, syncs your history across devices and brings you the latest model improvements",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            const InfoRow(icon: Icons.search, title: "PromptGPT can be inaccurate", description: "PromptGPT can provide inaccurate information about people, places, and facts."),
            const Divider(thickness: 1, color: Colors.grey, height: 70.0, indent: 16.0, endIndent: 16.0),
            const InfoRow(icon: Icons.lock, title: "Don't share sensitive info", description: "Chats may be reviewed and used to train our models."),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "By continuing, you agree to our terms and conditions and have read our privacy policy",
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to AuthPage when "Continue" is pressed
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const InfoRow({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(icon, color: Colors.white),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 15.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
