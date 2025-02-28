import 'package:flutter/material.dart';

class MenuButtonWidget extends StatelessWidget {
  final IconData? icon; // Agora opcional
  final String label;
  final VoidCallback onTap;

  const MenuButtonWidget({
    Key? key,
    this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, size: 28, color: Colors.black)
            else
              // Se não houver ícone, pode ser usado um espaço em branco ou nada:
              SizedBox(height: 28),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }
}