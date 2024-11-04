import 'package:flutter/material.dart';
import '../models/cards.dart';
import '../widgets/cards_widget.dart';
import 'communication.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Cards> buttons = [
    Cards("sim", Colors.green, Icons.thumb_up_alt_sharp),
    Cards("eu", Colors.yellow, Icons.person),
    Cards("preciso", Colors.pink, Icons.pan_tool),
    Cards("banheiro", Colors.blue, Icons.bathroom),
    Cards("não", Colors.green, Icons.thumb_down),
    Cards("você", Colors.yellow, Icons.person_outline),
    Cards("tenho", Colors.pink, Icons.accessibility_new),
    Cards("comer", Colors.blue, Icons.sentiment_satisfied),
    Cards("não sei", Colors.green, Icons.person_2),
    Cards("nós", Colors.yellow, Icons.person_pin),
    Cards("quero", Colors.pink, Icons.back_hand),
    Cards("brincar", Colors.blue, Icons.play_circle)
  ];

  List<String> selectedWords = [];
  int _selectedIndex = 0;
  bool _isMenuVisible = false;

  void addWord(String word) {
    setState(() {
      selectedWords.add(word);
    });
  }

  void clearWords() {
    setState(() {
      selectedWords.clear();
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C4C4C), 
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        leadingWidth: 100, // Ajuste de largura para comportar o Row
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: _toggleMenu, // Alterna o menu de Communication
                tooltip: 'Menu',
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  _onItemTapped(0); // Vai pra tela "Comunicação"
                },
                tooltip: 'Home',
              ),
            ),
          ],
        ),
        title: Text(
          _selectedIndex == 0 ? 'Comunicação' : 'Configurações',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, 
          ),
        ),
        centerTitle: true, 
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Ação para imprimir
            },
            tooltip: 'Imprimir',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _onItemTapped(1);
            },
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? Communication(
              buttons: buttons,
              selectedWords: selectedWords,
              addWord: addWord,
              clearWords: clearWords,
              isMenuVisible: _isMenuVisible,
              toggleMenu: _toggleMenu,
            )
          : Settings(),
    );
  }
}
