import 'package:flutter/material.dart';
import '../models/cards.dart';

class CardsWidget extends StatelessWidget {
  final Cards button;
  final VoidCallback onTap;

  CardsWidget({required this.button, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = screenWidth > 800 ? 30 : 24;
    final double fontSize = screenWidth > 800 ? 16 : 14;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: button.color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(button.icon, size: iconSize, color: Colors.black),
            const SizedBox(height: 5),
            Text(
              button.label,
              style: TextStyle(fontSize: fontSize, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
