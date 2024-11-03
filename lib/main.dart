import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(TDSnapApp());
}

class TDSnapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('App TEA'),
          backgroundColor: Colors.black87,
          actions: [
            IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          ],
        ),
        body: HomePage(),
      ),
    );
  }
}
