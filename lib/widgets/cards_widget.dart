import 'package:flutter/material.dart';
import '../models/cards.dart';

class CardsWidget extends StatelessWidget {
  final Cards button;
  final VoidCallback onTap;

  CardsWidget({required this.button, required this.onTap});

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
            Icon(button.icon, size: 30, color: Colors.black),
            const SizedBox(height: 5),
            Text(
              button.label,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
