import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(TDSnapApp());
}

class TDSnapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // oculta o "debug"
      home: HomePage(),
    );
  }
}
