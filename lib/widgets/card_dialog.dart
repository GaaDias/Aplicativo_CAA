import 'package:flutter/material.dart';
import '../models/cards.dart';
import '../data/database_helper.dart';
import '../services/arasaac_api.dart';
import '../services/pictogram_downloader.dart';

class CardDialog extends StatefulWidget {
  final bool isEditMode;
  final Cards? card;
  final void Function(String label, String pictogram, Color color, bool isActive)? onSave;
  final VoidCallback? onDelete;

  const CardDialog({
    Key? key,
    required this.isEditMode,
    this.card,
    this.onSave,
    this.onDelete,
  }) : super(key: key);

  @override
  _CardDialogState createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  late String label;
  late String selectedPictogram;
  late Color selectedColor;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    label = widget.card?.label ?? "";
    selectedPictogram = widget.card?.pictogram ?? "";
    selectedColor = widget.card?.color ?? Colors.blue;
    isActive = widget.card?.isActive ?? true;
  }

  void _confirmDeletion() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content: const Text("Tem certeza de que deseja excluir este card?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.onDelete != null) {
                  widget.onDelete!();
                }
                Navigator.of(context).pop();
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  /// Busca o pictograma pela palavra digitada usando a API.
  Future<void> _fetchPictogram(String keyword) async {
    final List<int> ids = await ArasaacApi.getPictogramIdsByKeyword(keyword);
    if (ids.isNotEmpty) {
      final int pictogramId = ids.first;
  
      String? localPath = await DatabaseHelper.getPictogramLocalPathById(pictogramId); // Correto: usa o método público
      if (localPath != null && localPath.isNotEmpty) {
        setState(() {
          selectedPictogram = localPath;
        });
      } else {
        final String onlineUrl = ArasaacApi.getPictogramUrlById(pictogramId);
        await PictogramDownloader.checkAndDownloadPictogram(pictogramId.toString(), onlineUrl);
  
        final String? newLocalPath = await DatabaseHelper.getPictogramLocalPathById(pictogramId); // Correto: usa o método público
        setState(() {
          selectedPictogram = newLocalPath ?? onlineUrl;
        });
      }
    } else {
      setState(() {
        selectedPictogram = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      const Color.fromARGB(255, 0, 255, 8),
      Colors.teal,
      const Color.fromARGB(255, 16, 31, 241),
      Colors.lightBlue,
      Colors.purple,
      Colors.pink,
      Colors.brown,
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              widget.isEditMode ? "Edição de Card" : "Criação de Card",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            right: 0,
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            ? Image.network(
                                selectedPictogram,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(child: Icon(Icons.error));
                                },
                              )
                            : Center(child: Text("Imagem", style: TextStyle(color: Colors.grey, fontSize: 16))),
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
                const SizedBox(width: 19),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      const Text("Palavra", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          label = value;
                        },
                        onSubmitted: (value) async {
                          await _fetchPictogram(value);
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
            const Text("Cor do Card", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
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
                        border: Border.all(color: selectedColor == color ? Colors.black : Colors.transparent, width: 2),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(vertical: 16),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isEditMode)
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Excluir Card',
                onPressed: () {
                  _confirmDeletion();
                },
              ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                if (label.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("O campo 'Palavra' não pode estar vazio!")),
                  );
                  return;
                }
                widget.onSave?.call(label, selectedPictogram, selectedColor, isActive);
                Navigator.of(context).pop();
              },
              child: const Text("Salvar", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ],
    );
  }

  void _selectPictogram(BuildContext context) async {
    // Busca pictogramas já cadastrados no banco (se houver)
    final pictogramData = await DatabaseHelper.getPictograms();
    final pictograms = pictogramData.map((p) => p['local_path'] as String).toList();

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
                  child: Image.network(
                    path,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
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
