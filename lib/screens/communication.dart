import 'package:flutter/material.dart';
import '../models/cards.dart';
import '../widgets/cards_widget.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class Communication extends StatefulWidget {
  final List<Cards> buttons;
  final List<String> selectedWords;
  final Function addWord;
  final Function clearWords;
  final VoidCallback addNewCard;
  final bool isMenuVisible;
  final VoidCallback toggleMenu;

  Communication({
    required this.buttons,
    required this.selectedWords,
    required this.addWord,
    required this.clearWords,
    required this.addNewCard,
    required this.isMenuVisible,
    required this.toggleMenu,
  });

  @override
  _CommunicationState createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> {
  final GlobalKey _parentContainerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double menuWidth = screenWidth > 800 ? screenWidth * 0.2 : screenWidth * 0.3;

    // Define o número de colunas para o grid de acordo com a largura da tela
    final int crossAxisCount = screenWidth > 800 ? 5 : 3;

    // Define o tamanho do card para calcular tamanhos responsivos
    final double cardWidth = (screenWidth - 32 - ((crossAxisCount - 1) * 20)) / crossAxisCount;

    return Column(
      children: [
        Container(
          key: _parentContainerKey,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          color: const Color.fromARGB(255, 182, 182, 182),
          child: Row(
            children: [
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Ação para "falar" as palavras selecionadas
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.12, 60),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.volume_up, color: Color(0xFF4C4C4C), size: 24),
                    const SizedBox(height: 4),
                    const Text("Falar", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
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
                      widget.selectedWords.join(" "),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => widget.clearWords(),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.12, 60),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.backspace, color: Color(0xFF4C4C4C), size: 24),
                    const SizedBox(height: 4),
                    const Text("Apagar", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  width: widget.isMenuVisible ? menuWidth : 0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: widget.isMenuVisible
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(Icons.settings),
                              title: Text("Settings"),
                              onTap: widget.toggleMenu,
                            ),
                            ListTile(
                              leading: Icon(Icons.info),
                              title: Text("About"),
                              onTap: widget.toggleMenu,
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ReorderableGridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemCount: widget.buttons.length,
                    itemBuilder: (context, index) {
                      final card = widget.buttons[index];
                      return CardsWidget(
                        key: ValueKey(card),
                        button: card,
                        iconSize: cardWidth * 0.4, // Ícone responsivo
                        fontSize: cardWidth * 0.15, // Fonte responsiva
                        onTap: () {
                          if (card.icon == Icons.add) {
                            widget.addNewCard();
                          } else {
                            widget.addWord(card.label);
                          }
                        },
                      );
                    },
                    onReorder: (oldIndex, newIndex) {
                      if (widget.buttons[oldIndex].icon == Icons.add || newIndex >= widget.buttons.length - 1) return;

                      setState(() {
                        final card = widget.buttons.removeAt(oldIndex);
                        widget.buttons.insert(newIndex, card);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}