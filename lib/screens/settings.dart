import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final int currentColumns; // Número atual de colunas
  final Function(int) onColumnsChanged; // Callback para atualizar o número de colunas

  Settings({
    required this.currentColumns,
    required this.onColumnsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(
      text: currentColumns.toString(),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Configurações',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Número de Colunas',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final int? newColumns = int.tryParse(_controller.text);
              if (newColumns != null && newColumns > 0) {
                onColumnsChanged(newColumns); // Atualiza o número de colunas
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Número de colunas atualizado para $newColumns!'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, insira um número válido!'),
                  ),
                );
              }
            },
            child: const Text('Atualizar Colunas'),
          ),
        ],
      ),
    );
  }
}
