import 'package:flutter/material.dart';
import '../models/cards.dart';
import 'communication.dart';
import 'settings.dart';
import 'historyScreen.dart';
import '../widgets/card_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cards> buttons = [];
  List<String> selectedWords = [];
  int _selectedIndex = 0;
  bool _isMenuVisible = false;
  bool _isEditMode = false;
  int _columns = 5;

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

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(),
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
          onSave: (label, pictogram, color) {
            setState(() {
              card.label = label;
              card.pictogram = pictogram;
              card.color = color;
            });
          },
          onDelete: () {
            setState(() {
              buttons.remove(card); // Atualiza a lista ao excluir o card
            });
            Navigator.of(context).pop(); // Fecha o pop-up após excluir
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
        onSave: (label, pictogram, color) {
          setState(() {
            if (isEditMode && card != null) {
              card.label = label;
              card.pictogram = pictogram; // Atualizado para "pictogram"
              card.color = color;
            } else {
              buttons.add(Cards(label, color, pictogram)); // Adiciona novo card com pictograma
            }
          });
        },
      );
    },
  );
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
                _onItemTapped(0);
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
              addNewCard: _addNewCard,
              isMenuVisible: _isMenuVisible,
              toggleMenu: _toggleMenu,
              isEditMode: _isEditMode,
              columns: _columns,
              editCard: _editCard,
            )
          : Settings(
              currentColumns: _columns,
              onColumnsChanged: _onColumnsChanged,
            ),
    );
  }
}