import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/drawer.dart';
import '../services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Karthik', lastName: 'Patchamatla');
  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'Prompt', lastName: 'GPT');

  List<ChatMessage> messages = <ChatMessage>[];
  bool isTyping = false;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Text(
              "PromptGPT",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      drawer: const DrawerWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (messages.isEmpty) _buildWelcomeMessage(),
          Expanded(
            child: DashChat(
              currentUser: _currentUser,
              messageOptions: MessageOptions(
                currentUserContainerColor: Colors.blueGrey[700],
                containerColor: const Color.fromARGB(255, 33, 33, 33),
                textColor: Colors.white,
                currentUserTextColor: Colors.white,
              ),
              inputOptions: InputOptions(
                inputTextStyle: const TextStyle(color: Colors.white),
                inputDecoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[850],
                  hintText: "Type your message...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
              onSend: (ChatMessage message) async {
                await handleSend(message);
              },
              messages: messages,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/homelogo.png',
              height: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome! What can I help with?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleSend(ChatMessage userMessage) async {
    setState(() {
      messages.insert(0, userMessage);
      isTyping = true;
      messages.insert(
        0,
        ChatMessage(
          user: _gptChatUser,
          createdAt: DateTime.now(),
          text: "Prompt GPT is typing...",
        ),
      );
    });

    try {
      String responseText = await getFullResponse(userMessage.text);
      ChatMessage responseMessage = ChatMessage(
        user: _gptChatUser,
        createdAt: DateTime.now(),
        text: responseText,
      );

      setState(() {
        messages.removeAt(0); // Remove "typing" message
        messages.insert(0, responseMessage);
        isTyping = false;
      });

      await _firestoreService.saveChatHistory(
        userMessage.text,
        responseText,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching response: ${e.toString()}")),
      );
      setState(() {
        messages.removeAt(0);
        isTyping = false;
      });
    }
  }

  Future<String> getFullResponse(String prompt) async {
    const String apiKey = 'iKmbpyYxW8KxM0upoiLZhoNXP4ScV9FmTMdgwVvI';

    int calculatedTokens = prompt.length < 50 ? 300 : 1000;

    final response = await http.post(
      Uri.parse('https://api.cohere.ai/generate'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'command-r-plus',
        'prompt': prompt,
        'max_tokens': calculatedTokens,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['text'] ?? 'No response text available.';
    } else {
      throw Exception('Failed to load response: ${response.reasonPhrase}');
    }
  }
}