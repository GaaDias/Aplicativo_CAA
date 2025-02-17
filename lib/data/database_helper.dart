import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'communication_history.db'),
      onCreate: (db, version) async {
        // Tabela para o histórico de frases
        await db.execute(
          "CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT, phrase TEXT, timestamp TEXT)",
        );
        // Tabela para os pictogramas
        await db.execute('''
          CREATE TABLE pictograms(
            id INTEGER PRIMARY KEY,
            name TEXT,
            category TEXT,
            local_path TEXT,
            online_url TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> printTables() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print("Tabelas existentes no banco:");
    for (var table in tables) {
      print(table['name']);
    }
  }

  // Funções para o histórico (já existentes)
  static Future<void> savePhrase(String phrase) async {
    final db = await _openDatabase();
    DateTime now = DateTime.now().toUtc().subtract(Duration(hours: 3));
    String localTimestamp = now.toIso8601String();
    await db.insert(
      'history',
      {'phrase': phrase, 'timestamp': localTimestamp},
    );
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await _openDatabase();
    return await db.query('history', orderBy: 'timestamp DESC');
  }

  static Future<void> deleteOldPhrases() async {
    final db = await _openDatabase();
    DateTime oneMonthAgo = DateTime.now().subtract(Duration(days: 30));
    await db.delete(
      'history',
      where: "timestamp < ?",
      whereArgs: [oneMonthAgo.toIso8601String()],
    );
  }

  static Future<List<Map<String, dynamic>>> getHistoryFiltered(int days) async {
    final db = await _openDatabase();
    DateTime startDate = DateTime.now().subtract(Duration(days: days));
    final data = await db.query(
      'history',
      where: "timestamp >= ?",
      whereArgs: [startDate.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
    return data;
  }

  static Future<void> clearHistory() async {
    final db = await _openDatabase();
    await db.delete('history');
  }

  // Funções para pictogramas
  static Future<void> insertPictogram(Map<String, dynamic> pictogram) async {
    final db = await _openDatabase();
    await db.insert('pictograms', pictogram, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getPictograms() async {
    final db = await _openDatabase();
    return await db.query('pictograms');
  }

  static Future<String?> getPictogramLocalPath(String name) async {
    final db = await _openDatabase();
    final result = await db.query(
      'pictograms',
      where: "LOWER(name) = ?",
      whereArgs: [name.toLowerCase()],
    );
    if (result.isNotEmpty) {
      return result.first['local_path'] as String;
    }
    return null;
  }
}