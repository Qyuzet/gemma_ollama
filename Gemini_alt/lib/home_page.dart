import 'package:flutter/material.dart';
import 'note_editor.dart';
import 'chat_assistant.dart';

class NotesHomePage extends StatefulWidget {
  @override
  _NotesHomePageState createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  List<Map<String, String>> notes = [];

  void addNote() async {
    Map<String, String>? newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditorPage()),
    );

    if (newNote != null) {
      setState(() {
        notes.add(newNote);
      });
    }
  }

  void editNoteAt(int index) async {
    Map<String, String>? updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorPage(
          note: notes[index],
        ),
      ),
    );

    if (updatedNote != null) {
      setState(() {
        notes[index] = updatedNote;
      });
    }
  }

  void deleteNoteAt(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void openChatAssistant() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatAssistantPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: openChatAssistant,
          )
        ],
      ),
      body: notes.isEmpty
          ? Center(
        child: Text(
          'No notes yet. Tap the + button to add one.',
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              color: Colors.teal.shade50,
              child: ListTile(
                title: Text(
                  notes[index]['title'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal.shade900,
                  ),
                ),
                subtitle: Text(
                  notes[index]['content']?.split('\n').first ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.teal.shade700),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteNoteAt(index),
                ),
                onTap: () => editNoteAt(index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
