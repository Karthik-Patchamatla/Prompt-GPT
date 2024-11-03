import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/chathistoryscreen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userEmail = user?.email ?? 'Guest';
    String userInitial = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : '';

    const Color textColor = Colors.white;
    const Color iconColor = Colors.white;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        color: const Color.fromARGB(255, 54, 53, 53),
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color.fromARGB(255, 70, 70, 70),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple[400],
                    radius: 25,
                    child: Text(
                      userInitial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(  // Use Expanded to allow the text to take available space
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello,',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis, // This will truncate with an ellipsis if too long
                          maxLines: 1, // Limit to one line
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: iconColor),
              title: const Text('Home', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: iconColor),
              title: const Text('Settings', style: TextStyle(color: textColor)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history, color: iconColor),
              title: const Text('Chat History', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChatHistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: iconColor),
              title: const Text('Logout', style: TextStyle(color: textColor)),
              onTap: () async {
                await auth.signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
