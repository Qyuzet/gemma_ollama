import 'package:flutter/material.dart';

class NoteEditorPage extends StatefulWidget {
  final Map<String, String>? note;

  NoteEditorPage({this.note});

  @override
  _NoteEditorPageState createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note?['title'] ?? '';
      _contentController.text = widget.note?['content'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'Add Note' : 'Edit Note',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.teal.shade900),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Colors.teal.shade900),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    Navigator.pop(context, {
                      'title': _titleController.text,
                      'content': _contentController.text,
                    });
                  }
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}