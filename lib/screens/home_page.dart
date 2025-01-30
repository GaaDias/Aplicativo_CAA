import 'package:flutter/material.dart';
import '../models/cards.dart';
import 'communication.dart';
import 'settings.dart';
import 'historyScreen.dart';
import '../widgets/card_dialog.dart';
import '../widgets/menu_button_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cards> cardsList = [];
  List<Cards> menuCardsList = [];
  List<String> selectedWords = [];
  bool _isMenuVisible = false;
  bool _isEditMode = false;
  int _columns = 7;

  void addWord(String word) {
    setState(() {
      selectedWords.add(word);
    });
  }

  void clearWords() {
    setState(() {
      if (selectedWords.isNotEmpty) {
        selectedWords.removeLast();
      }
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Settings(
          currentColumns: _columns,
          onColumnsChanged: _onColumnsChanged,
        ),
      ),
    );
  }

  void _addNewCard() {
    _showCardDialog(isEditMode: false);
  }

  void _editCard(Cards card) {
    showDialog(
      context: context,
      builder: (context) {
        return CardDialog(
          isEditMode: true,
          card: card,
          onSave: (label, pictogram, color, isActive) {
            setState(() {
              card.label = label;
              card.pictogram = pictogram;
              card.color = color;

              if (card.isActive != isActive) {
                card.isActive = isActive;
                _reorganizeCards();
              }
            });
          },
          onDelete: () {
            setState(() {
              cardsList.remove(card);
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _onColumnsChanged(int newColumns) {
    setState(() {
      _columns = newColumns;
    });
  }

  void _showCardDialog({required bool isEditMode, Cards? card}) {
    showDialog(
      context: context,
      builder: (context) {
        return CardDialog(
          isEditMode: isEditMode,
          card: card,
          onSave: (label, pictogram, color, isActive) {
            setState(() {
              if (isEditMode && card != null) {
                card.label = label;
                card.pictogram = pictogram;
                card.color = color;

                if (card.isActive != isActive) {
                  card.isActive = isActive;
                  _reorganizeCards();
                }
              } else {
                final newCard =
                    Cards(label, color, pictogram, isActive: isActive);
                cardsList.add(newCard);
                _reorganizeCards();
              }
            });
          },
        );
      },
    );
  }

  void _reorganizeCards() {
    final activeCards = cardsList.where((card) => card.isActive).toList();
    final inactiveCards = cardsList.where((card) => !card.isActive).toList();

    setState(() {
      cardsList = [...activeCards, ...inactiveCards];
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
        leadingWidth: 150,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: _toggleMenu,
              tooltip: 'Menu',
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Voltar para a tela inicial
              },
              tooltip: 'Home',
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: _navigateToHistory,
              tooltip: 'Histórico e Evolução',
            ),
          ],
        ),
        title: const Text(
          'Comunicação',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: _isEditMode,
                onChanged: (value) {
                  setState(() {
                    _isEditMode = value;
                  });
                },
                activeTrackColor: Colors.grey,
                inactiveTrackColor: Colors.grey[400],
                activeColor: Colors.black,
                inactiveThumbColor: Colors.black,
              ),
              const SizedBox(width: 1),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Ação para edição
                },
                tooltip: 'Editar',
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewCard,
            tooltip: 'Criar Card',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Ação para imprimir
            },
            tooltip: 'Imprimir',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: Communication(
        cardsList: cardsList,
        menuCardsList: menuCardsList,
        selectedWords: selectedWords,
        addWord: addWord,
        clearWords: clearWords,
        addNewCard: _addNewCard,
        isMenuVisible: _isMenuVisible,
        toggleMenu: _toggleMenu,
        isEditMode: _isEditMode,
        columns: _columns,
        editCard: _editCard,
      ),
    );
  }
}