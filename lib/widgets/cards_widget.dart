import 'package:flutter/material.dart';
import '../models/cards.dart';

class CardsWidget extends StatelessWidget {
  final Cards button;
  final VoidCallback onTap;
  final double fontSize; 
  final double iconSize; 

  CardsWidget({
    Key? key,
    required this.button,
    required this.onTap,
    this.iconSize = 24.0, 
    this.fontSize = 14.0, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 4),
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
