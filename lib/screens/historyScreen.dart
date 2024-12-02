import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> history = [
    {
      "phrase": "Quero brincar",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
    },
    {
      "phrase": "Estou com fome",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
    },
    {
      "phrase": "Preciso de ajuda",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
    },
  ];

  String formatDate(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Histórico de Frases",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4C4C4C),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                "Nenhum histórico disponível.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      item["phrase"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Criado em: ${formatDate(item["timestamp"])}"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {

                    },
                  ),
                );
              },
            ),
    );
  }
}
