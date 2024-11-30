import 'package:flutter/material.dart';
import '../models/cards.dart';
import '../data/pictogram_database.dart';

class CardDialog extends StatefulWidget {
  final bool isEditMode;
  final Cards? card;
  final void Function(String label, String pictogram, Color color)? onSave;

  const CardDialog({
    Key? key,
    required this.isEditMode,
    this.card,
    this.onSave,
  }) : super(key: key);

  @override
  _CardDialogState createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  late String label;
  late String selectedPictogram;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    label = widget.card?.label ?? "";
    selectedPictogram = widget.card?.pictogram ?? ""; // Inicia vazio
    selectedColor = widget.card?.color ?? Colors.blue; // Cor padrão
  }

  void _updatePictogram(String input) {
    // Busca o pictograma relacionado à palavra digitada
    String? newPictogram = PictogramDatabase.getPictogramByKeyword(input);
    setState(() {
      selectedPictogram = newPictogram ?? ""; // Atribui vazio se não encontrar
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.yellow,
      Colors.blue,
      Colors.lightBlue,
      Colors.purple,
      Colors.pink,
      Colors.brown,
      Colors.teal,
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Center(
        child: Text(
          widget.isEditMode ? "Edição de Card" : "Criação de Card",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coluna da imagem
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: selectedPictogram.isNotEmpty
                            ? Image.asset(
                                selectedPictogram,
                                fit: BoxFit.contain,
                              )
                            : Center(
                                child: Text(
                                  "Imagem",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () {
                              // Lógica para abrir a câmera
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _selectPictogram(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Coluna da palavra
                Expanded( 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      const Text(
                        "Palavra",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          label = value; // Armazena o valor digitado.
                        },
                        onSubmitted: (value) {
                          setState(() {
                              selectedPictogram = PictogramDatabase.getPictogramByKeyword(value)!;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Digite a palavra...",
                        ),
                        controller: TextEditingController(text: label),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Cor do Card",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (label.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("O campo 'Palavra' não pode estar vazio!"),
                        ),
                      );
                      return;
                    }
                    widget.onSave?.call(label, selectedPictogram, selectedColor);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Salvar", 
                    style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectPictogram(BuildContext context) {
    final pictograms = PictogramDatabase.getAllPictograms(); // Todos os pictogramas

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Escolha um Pictograma"),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pictograms.map((path) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPictogram = path;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    path,
                    width: 50,
                    height: 50,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}