import 'package:flutter/material.dart';
import '../models/cards.dart';

class CardsWidget extends StatelessWidget {
  final Cards button;
  final VoidCallback onTap;

  CardsWidget({required this.button, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    
    // Defina o tamanho dos cards diretamente aqui
    final double cardWidth = screenWidth > 800 ? 80 : 40; // largura dos cards
    final double cardHeight = screenWidth > 800 ? 80 : 40; // altura dos cards
    final double iconSize = screenWidth > 800 ? 24 : 20;
    final double fontSize = screenWidth > 800 ? 14 : 12;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
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