import 'package:flutter/material.dart';
import 'package:note_app/ui/note_screen.dart';

// This is the home page
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note App"),
        backgroundColor: Colors.black54,
      ),
      body: BodyScreen(), // inside note_screen.dart
    );
  }
}
