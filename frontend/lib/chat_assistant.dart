import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChatAssistantPage extends StatefulWidget {
  @override
  _ChatAssistantPageState createState() => _ChatAssistantPageState();
}

class _ChatAssistantPageState extends State<ChatAssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String _currentStreamingResponse = '';
  Timer? _streamTimer;

  Future<void> sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _isLoading = true;
      _currentStreamingResponse = ''; // Reset streaming response
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:11434/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model':'gemma2:latest',
          'messages': [
            {'role': 'user', 'content': userMessage}
          ],
        }),
      );

      if (response.statusCode == 200) {
        // Split the response body into individual JSON lines
        final jsonLines = response.body.trim().split('\n');

        // Start streaming the response
        _streamResponseWords(jsonLines);
      } else {
        setState(() {
          _messages.add({'role': 'error', 'content': 'HTTP Status Code: ${response.statusCode}'});
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'error', 'content': 'Failed to connect to the API: $e'});
        _isLoading = false;
      });
    }

    _messageController.clear();
  }

  void _streamResponseWords(List<String> jsonLines) {
    // Collect all words from the response
    List<String> allWords = [];
    for (var line in jsonLines) {
      try {
        final decodedLine = jsonDecode(line);
        if (decodedLine != null &&
            decodedLine['message'] != null &&
            decodedLine['message']['content'] != null) {
          // Split the content into words
          allWords.addAll(decodedLine['message']['content'].toString().split(' '));
        }
      } catch (e) {
        print("Error parsing JSON line: $e");
      }
    }

    // Create a timer to stream words one by one
    int currentWordIndex = 0;
    _streamTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (currentWordIndex < allWords.length) {
        setState(() {
          _currentStreamingResponse += allWords[currentWordIndex] + ' ';

          // Update the last message with the current streaming response
          if (_messages.isNotEmpty && _messages.last['role'] == 'assistant') {
            _messages.last['content'] = _currentStreamingResponse;
          } else {
            _messages.add({
              'role': 'assistant',
              'content': _currentStreamingResponse
            });
          }
        });
        currentWordIndex++;
      } else {
        // Stop the timer when all words are displayed
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer if the widget is disposed
    _streamTimer?.cancel();
    super.dispose();
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
