import 'package:flutter/material.dart';
import '../models/cards.dart';

class CardsWidget extends StatelessWidget {
  final Cards button;
  final VoidCallback onTap;
  final double fontSize;
  final double pictogramSize;

  const CardsWidget({
    Key? key,
    required this.button,
    required this.onTap,
    required this.pictogramSize,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se o caminho começa com "http", usamos Image.network; caso contrário, Image.asset.
    final Widget pictogramWidget = button.pictogram.startsWith("http")
        ? Image.network(
            button.pictogram,
            width: pictogramSize,
            height: pictogramSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          )
        : Image.asset(
            button.pictogram,
            width: pictogramSize,
            height: pictogramSize,
            fit: BoxFit.contain,
          );

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
            pictogramWidget,
            const SizedBox(height: 5),
            Text(
              button.label,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
