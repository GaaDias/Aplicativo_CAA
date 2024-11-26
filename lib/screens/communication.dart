import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/cards.dart';
import '../widgets/cards_widget.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class Communication extends StatefulWidget {
  final List<Cards> buttons;
  final List<String> selectedWords;
  final Function addWord;
  final VoidCallback clearWords;
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
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _configureTts();
  }

  void _configureTts() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setVoice({"name": "pt-br-x-afs-network", "locale": "pt-BR"});
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakContainerContent() async {
    String text = widget.selectedWords.join(" ");
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  void _addNewCard(String label, IconData icon, Color color) {
    setState(() {
      widget.buttons.insert(0, Cards(label, color, icon)); // Adiciona o novo card na primeira posição
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double menuWidth = screenWidth > 800 ? screenWidth * 0.2 : screenWidth * 0.3;
    final int crossAxisCount = screenWidth > 800 ? 5 : 3;
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
                onPressed: _speakContainerContent,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.12, 60),
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
                      color: const Color(0xFF4C4C4C),
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
                onPressed: widget.clearWords,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.12, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.backspace, color: Color(0xFF4C4C4C), size: 24),
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
                              leading: const Icon(Icons.settings),
                              title: const Text("Settings"),
                              onTap: widget.toggleMenu,
                            ),
                            ListTile(
                              leading: const Icon(Icons.info),
                              title: const Text("About"),
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
                        iconSize: cardWidth * 0.4,
                        fontSize: cardWidth * 0.15,
                        onTap: () {
                          widget.addWord(card.label);
                        },
                      );
                    },
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        final card = widget.buttons.removeAt(oldIndex);
                        widget.buttons.insert(newIndex, card); // Reordena livremente
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