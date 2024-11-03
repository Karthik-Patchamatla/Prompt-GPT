// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';

class ChatHistoryScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        title: const Text('Chat History', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 10, 10, 10), // Dark app bar
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white), // White icon for visibility
            onPressed: () async {
              await firestoreService.clearChatHistory();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getChatHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chat history found.', style: TextStyle(color: Colors.white))); // White text
          }
          final chatHistory = snapshot.data!;

          return Container(
            color: Colors.black, // Matches the dark background
            child: ListView.builder(
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final chat = chatHistory[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850], // Dark grey for cards
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[300], // Lighter color for visibility
                          ),
                        ),
                        Text(
                          chat['question'] ?? '',
                          style: const TextStyle(fontSize: 16, color: Colors.white), // White text for questions
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Response:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[300], // Lighter color for visibility
                          ),
                        ),
                        Text(
                          chat['answer'] ?? '',
                          style: const TextStyle(fontSize: 16, color: Colors.white), // White text for answers
                        ),
                        const SizedBox(height: 10),
                        Text(
                          chat['timestamp'] != null
                              ? DateFormat.yMMMd().add_jm().format(
                                  (chat['timestamp'] as Timestamp).toDate())
                              : '',
                          style: TextStyle(
                            color: Colors.grey[400], // Lighter grey for timestamp
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
