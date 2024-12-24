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

  // Using Gemini API Key for this controller
  final String _apiKey = 'API_KEY'; // Replace with your actual API key
  final String _apiEndpoint = 'API_LINK'; // Replace with your actual API endpoint

  Future<void> sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _isLoading = true;
    });

    try {
      final uri = Uri.parse('$_apiEndpoint?key=$_apiKey');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [{'text': userMessage}]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        try {
          final decodedBody = jsonDecode(response.body);

          if (decodedBody != null &&
              decodedBody['candidates'] != null &&
              decodedBody['candidates'].isNotEmpty &&
              decodedBody['candidates'][0]['content'] != null &&
              decodedBody['candidates'][0]['content']['parts'] != null &&
              decodedBody['candidates'][0]['content']['parts'].isNotEmpty) {

            final geminiResponse = decodedBody['candidates'][0]['content']['parts'][0]['text'];
            setState(() {
              _messages.add({'role': 'assistant', 'content': geminiResponse});
            });
          } else {
            setState(() {
              _messages.add({'role': 'error', 'content': 'Invalid response structure from Gemini'});
            });
          }
        } on FormatException catch (e) {
          setState(() {
            _messages.add({'role': 'error', 'content': 'JSON Parsing Error: $e'});
          });
        }
      } else {
        setState(() {
          _messages.add({'role': 'error', 'content': 'HTTP Status Code: ${response.statusCode}, Response: ${response.body}'});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'error', 'content': 'Failed to connect to Gemini API: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text('Gemini Chat Assistant', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[600] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      message['content'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.blue[900],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) 
            CircularProgressIndicator(color: Colors.blue),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue[50],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: sendMessage,
                  icon: Icon(Icons.send),
                  color: Colors.blue[700],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String message, {bool isUser = false, bool isAssistant = false, bool isError = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isUser
            ? Colors.blue.shade100
            : isAssistant
            ? Colors.grey.shade200
            : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        message,
        style: TextStyle(
          color: isError ? Colors.red.shade900 : Colors.black,
        ),
      ),
    );
  }
}