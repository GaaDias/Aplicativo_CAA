import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/cards.dart';
import '../widgets/cards_widget.dart';

class Communication extends StatefulWidget {
  final List<Cards> cardsList;
  final List<String> selectedWords;
  final Function addWord;
  final VoidCallback clearWords;
  final VoidCallback addNewCard;
  final Function(Cards card) editCard;
  final bool isMenuVisible;
  final VoidCallback toggleMenu;
  final bool isEditMode;
  final int columns;

  Communication({
    required this.cardsList,
    required this.selectedWords,
    required this.addWord,
    required this.clearWords,
    required this.addNewCard,
    required this.editCard,
    required this.isMenuVisible,
    required this.toggleMenu,
    required this.isEditMode,
    required this.columns,
  });

  @override
  _CommunicationState createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _configureTts();
  }

  void _configureTts() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setVoice({"name": "pt-br-x-afs-network", "locale": "pt-BR"});
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
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

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = widget.columns;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double menuWidth = screenWidth > 800 ? screenWidth * 0.2 : screenWidth * 0.3;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: const Color.fromARGB(255, 182, 182, 182),
          child: Row(
            children: [
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
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.backspace, color: Colors.black),
                    Text("Apagar", style: TextStyle(color: Colors.black)),
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
                              title: const Text("Configurações"),
                              onTap: widget.toggleMenu,
                            ),
                            ListTile(
                              leading: const Icon(Icons.info),
                              title: const Text("Sobre"),
                              onTap: widget.toggleMenu,
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    final pictogramScale = widget.isMenuVisible ? 0.95 : 1.0;
                    final cardWidth = (availableWidth - 64) / (crossAxisCount + 0.5);
                    final cardSpacing = (availableWidth - 64 - (crossAxisCount * cardWidth)) / (crossAxisCount - 1);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: cardSpacing,
                          mainAxisSpacing: cardSpacing,
                          childAspectRatio: 1,
                        ),
                        itemCount: widget.isEditMode
                            ? widget.cardsList.length
                            : widget.cardsList.where((card) => card.isActive).length, 
                        itemBuilder: (context, index) {                          
                          final cardsToShow = widget.isEditMode
                              ? widget.cardsList
                              : widget.cardsList.where((card) => card.isActive).toList();

                          final card = cardsToShow[index];

                          if (widget.isEditMode) {                  
                            return Draggable<int>(
                              data: index,
                              feedback: Material(
                                type: MaterialType.transparency,
                                child: SizedBox(
                                  width: cardWidth,
                                  height: cardWidth,
                                  child: CardsWidget(
                                    button: card,
                                    pictogramSize: cardWidth * 0.5 * pictogramScale,
                                    fontSize: cardWidth * 0.2 * pictogramScale,
                                    onTap: () {},
                                  ),
                                ),
                              ),
                              childWhenDragging: Container(),
                              child: DragTarget<int>(
                                // ignore: deprecated_member_use
                                onAccept: (fromIndex) {
                                  setState(() {
                                    final temp = widget.cardsList[fromIndex];
                                    widget.cardsList[fromIndex] = widget.cardsList[index];
                                    widget.cardsList[index] = temp;
                                  });
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return Opacity(
                                    opacity: card.isActive ? 1.0 : 0.3,
                                    child: CardsWidget(
                                      button: card,
                                      pictogramSize: cardWidth * 0.5 * pictogramScale,
                                      fontSize: cardWidth * 0.2 * pictogramScale,
                                      onTap: () {
                                        widget.editCard(card);
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return CardsWidget(
                              button: card,
                              pictogramSize: cardWidth * 0.5 * pictogramScale,
                              fontSize: cardWidth * 0.2 * pictogramScale,
                              onTap: () {
                                if (card.isActive) {
                                  widget.addWord(card.label); 
                                }
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}