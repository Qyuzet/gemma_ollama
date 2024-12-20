import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatAssistantPage extends StatefulWidget {
  @override
  _ChatAssistantPageState createState() => _ChatAssistantPageState();
}

class _ChatAssistantPageState extends State<ChatAssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _isLoading = true;
    });

    try {
      // Debug: Printing the message sent to backend
      print("Sending message to the backend: $userMessage");

      // Sending HTTP POST request
      final response = await http.post(
        Uri.parse('http://10.25.85.106:11434/api/chat'), // Use the correct IP address
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'messages': [
            {'role': 'user', 'content': userMessage}
          ],
        }),
      );


      // Debug: Printing response details
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);

        if (decodedBody != null && decodedBody.containsKey('message')) {
          final gemmaResponse = decodedBody['message']['content'];
          setState(() {
            _messages.add({'role': 'assistant', 'content': gemmaResponse});
          });
        } else {
          print("Error: No content found in response message");
          setState(() {
            _messages.add({'role': 'assistant', 'content': "No content in message"});
          });
        }
      } else {
        print("Failed to connect. HTTP Status Code: ${response.statusCode}");
        setState(() {
          _messages.add({'role': 'error', 'content': 'HTTP Status Code: ${response.statusCode}'});
        });
      }
    } catch (e) {
      // Debug: Printing error when connection fails
      print("Error connecting to the backend: $e");
      setState(() {
        _messages.add({'role': 'error', 'content': 'Failed to connect to the API: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gemma AI Assistant', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['role'] == 'user';
                  final isAssistant = message['role'] == 'assistant';
                  return _buildChatMessage(message['content'] ?? '', isUser: isUser, isAssistant: isAssistant);
                },
              ),
            ),
            if (_isLoading) CircularProgressIndicator(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (value) => sendMessage(),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: Text('Send'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(String message, {bool isUser = false, bool isAssistant = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(message),
    );
  }
}
