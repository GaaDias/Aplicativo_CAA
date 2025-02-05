import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'communication_history.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT, phrase TEXT, timestamp TEXT)",
        );
      },
      version: 1,
    );
  }

  // Função para salvar uma frase falada no histórico
  static Future<void> savePhrase(String phrase) async {
    final db = await _openDatabase();

    // Captura a data UTC e ajusta manualmente para o fuso local
    DateTime now = DateTime.now().toUtc().subtract(Duration(hours: 3)); // Ajuste manual para UTC-3

    String localTimestamp = now.toIso8601String(); // Salva o horário correto

    await db.insert(
      'history',
      {'phrase': phrase, 'timestamp': localTimestamp},
    );
  }

  // Função para recuperar o histórico de frases
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await _openDatabase();
    return await db.query('history', orderBy: 'timestamp DESC');
  }

  // Função para deletar frases antigas
  static Future<void> deleteOldPhrases() async {
    final db = await _openDatabase();

    // Calcula a data de 30 dias atrás
    DateTime oneMonthAgo = DateTime.now().subtract(Duration(days: 30));

    // Deleta todas as frases anteriores a essa data
    await db.delete(
      'history',
      where: "timestamp < ?",
      whereArgs: [oneMonthAgo.toIso8601String()],
    );
  }

  // Pega o historico filtrado
  static Future<List<Map<String, dynamic>>> getHistoryFiltered(int days) async {
    final db = await _openDatabase();

    // Calcula a data inicial com base no filtro
    DateTime startDate = DateTime.now().subtract(Duration(days: days));

    final data = await db.query(
      'history',
      where: "timestamp >= ?",
      whereArgs: [startDate.toIso8601String()],
      orderBy: 'timestamp DESC',
    );

    return data;
  }

  // Deleta o historico (vai ser usado apenas para teste)
  static Future<void> clearHistory() async {
    final db = await _openDatabase();
    await db.delete('history'); // Remove todas as frases do histórico
  }
}
