import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    DatabaseHelper.deleteOldPhrases(); // Remove frases antigas automaticamente
    _loadHistory(30);
  }

  // Função para carregar o histórico do banco de dados
  Future<void> _loadHistory(int days) async {
    final data = await DatabaseHelper.getHistoryFiltered(days); // Agora está correto!

    setState(() {
      history = data;
    });
  }

  String formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);

    // Formatar dia e mês com zero à esquerda, se necessário
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();

    // Formatar hora e minuto com zero à esquerda
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return "$day/$month/$year - $hour:$minute";
  }

  int selectedDays = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoramento de Frases", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4C4C4C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // BOTÃO PARA LIMPAR HISTÓRICO (Fácil de remover depois)
                TextButton(
                  onPressed: () async {
                    await DatabaseHelper.clearHistory();
                    _loadHistory(selectedDays);
                  },
                  child: const Text("Limpar Histórico", style: TextStyle(color: Colors.red)),
                ),

                // FILTRO DE PERÍODO
                Row(
                  children: [
                    const Text("Filtrar por período: "),
                    const SizedBox(width: 15),
                    DropdownButton<int>(
                      value: selectedDays,
                      items: [
                        DropdownMenuItem(value: 7, child: Text("Últimos 7 dias")),
                        DropdownMenuItem(value: 15, child: Text("Últimos 15 dias")),
                        DropdownMenuItem(value: 30, child: Text("Últimos 30 dias")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedDays = value;
                            _loadHistory(selectedDays);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: history.isEmpty
                ? const Center(child: Text("Nenhum histórico disponível.", style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(item["phrase"], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Usada em: ${formatDate(item["timestamp"])}"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}