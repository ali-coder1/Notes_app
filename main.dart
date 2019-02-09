import 'package:flutter/material.dart';
import 'package:note_app/ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      home: Home(), // inside home.dart
    );
  }
}
