import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/cards.dart';
import '../widgets/cards_widget.dart';

class Communication extends StatelessWidget {
  final List<Cards> buttons;
  final List<String> selectedWords;
  final Function addWord;
  final Function clearWords;

  Communication({
    required this.buttons,
    required this.selectedWords,
    required this.addWord,
    required this.clearWords,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity, // largura da tela toda
          padding: const EdgeInsets.all(8.0),
          color: const Color.fromARGB(255, 182, 182, 182), // Cor de fundo do container pai
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // ação da voz
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(90, 70),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/f7--chat-bubble-fill.svg', 
                      width: 24,
                      height: 24,
                      color: Color(0xFF4C4C4C), 
                    ),
                    const SizedBox(height: 4),
                    const Text("Falar", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Espaço do botão para o container filho
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 60, 
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), 
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      selectedWords.join(" "),
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Espaço entre o container filho e o botão
              ElevatedButton(
                onPressed: () => clearWords(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(90, 70), 
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.backspace, color: Color(0xFF4C4C4C)),
                    const SizedBox(height: 4), // Espaço entre o ícone e o texto
                    const Text("Apagar", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return CardsWidget(
                button: buttons[index],
                onTap: () => addWord(buttons[index].label),
              );
            },
          ),
        ),
      ],
    );
  }
}
