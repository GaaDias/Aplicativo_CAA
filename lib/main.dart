import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(CAALumaApp());
}

class CAALumaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // oculta o "debug"
      home: LoginScreen(),
    );
  }
}
