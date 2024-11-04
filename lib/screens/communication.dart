import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/cards.dart';
import '../widgets/cards_widget.dart';

class Communication extends StatefulWidget {
  final List<Cards> buttons;
  final List<String> selectedWords;
  final Function addWord;
  final Function clearWords;
  final bool isMenuVisible;
  final VoidCallback toggleMenu;

  Communication({
    required this.buttons,
    required this.selectedWords,
    required this.addWord,
    required this.clearWords,
    required this.isMenuVisible,
    required this.toggleMenu,
  });

  @override
  _CommunicationState createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> with SingleTickerProviderStateMixin {
  final GlobalKey _parentContainerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double menuWidth = screenWidth > 800 ? screenWidth * 0.2 : screenWidth * 0.3;
    final int gridCrossAxisCount = screenWidth > 800 ? 5 : screenWidth > 600 ? 4 : 2;
    final double childAspectRatio = screenWidth > 800 ? 1.2 : 1.3;

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
                  minimumSize: Size(screenWidth * 0.12, 60), // Tamanho limitado
                  padding: EdgeInsets.symmetric(horizontal: 12),
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
                  minimumSize: Size(screenWidth * 0.12, 60), // Tamanho limitado
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
        const SizedBox(height: 10),
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: widget.isMenuVisible ? screenWidth - menuWidth : screenWidth,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCrossAxisCount,
                      childAspectRatio: childAspectRatio,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: widget.buttons.length,
                    itemBuilder: (context, index) {
                      return CardsWidget(
                        button: widget.buttons[index],
                        onTap: () => widget.addWord(widget.buttons[index].label),
                      );
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
