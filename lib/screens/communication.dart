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
  final bool isEditMode;
  final int columns;

  Communication({
    required this.buttons,
    required this.selectedWords,
    required this.addWord,
    required this.clearWords,
    required this.addNewCard,
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

  void _showEditCardDialog(Cards card) {
    showDialog(
      context: context,
      builder: (context) {
        String label = card.label;
        IconData selectedIcon = card.icon;
        Color selectedColor = card.color;
        final List<IconData> icons = [
          Icons.person,
          Icons.home,
          Icons.favorite,
          Icons.thumb_up,
          Icons.star,
          Icons.cake,
          Icons.access_alarm,
        ];
        final List<Color> colors = [
          Colors.white,
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.purple,
        ];

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Editar Card"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => label = value,
                    decoration: const InputDecoration(labelText: "Palavra"),
                    controller: TextEditingController(text: label),
                  ),
                  const SizedBox(height: 16),
                  const Text("Selecione um Ícone"),
                  Wrap(
                    spacing: 8,
                    children: icons.map((icon) {
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedIcon == icon ? Colors.grey[300] : null,
                          ),
                          child: Icon(icon, color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text("Selecione uma Cor"),
                  Wrap(
                    spacing: 8,
                    children: colors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      card.label = label;
                      card.icon = selectedIcon;
                      card.color = selectedColor;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = widget.columns; // Número de colunas ajustável pelo usuário
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth - 32) / (crossAxisCount + 0.5);
    final double menuWidth = screenWidth > 800 ? screenWidth * 0.2 : screenWidth * 0.3;
    final double cardSpacing = (screenWidth - (crossAxisCount * cardWidth)) / (crossAxisCount - 1);


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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: widget.isEditMode
                      ? ReorderableGridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: cardSpacing, // Espaçamento horizontal automático
                            mainAxisSpacing: cardSpacing, // Espaçamento vertical automático
                            childAspectRatio: 1, // Proporção largura/altura dos cards
                          ),
                          itemCount: widget.buttons.length,
                          itemBuilder: (context, index) {
                            final card = widget.buttons[index];
                            return CardsWidget(
                              key: ValueKey(card),
                              button: card,
                              iconSize: cardWidth * 0.35,
                              fontSize: cardWidth * 0.2,
                              onTap: () {
                                _showEditCardDialog(card);
                              },
                            );
                          },
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              final card = widget.buttons.removeAt(oldIndex);
                              widget.buttons.insert(newIndex, card);
                            });
                          },
                        )
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: cardSpacing, // Espaçamento horizontal automático
                            mainAxisSpacing: cardSpacing, // Espaçamento vertical automático
                            childAspectRatio: 1, // Proporção largura/altura dos cards
                          ),
                          itemCount: widget.buttons.length,
                          itemBuilder: (context, index) {
                            final card = widget.buttons[index];
                            return CardsWidget(
                              button: card,
                              iconSize: cardWidth * 0.35,
                              fontSize: cardWidth * 0.2,
                              onTap: () {
                                widget.addWord(card.label);
                              },
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