import 'package:dio/dio.dart';

class ArasaacApi {
  static final Dio _dio = Dio();

  /// Busca os IDs dos pictogramas correspondentes à palavra-chave,
  /// utilizando o endpoint:
  /// https://api.arasaac.org/v1/pictograms/br/search/{keyword}
  /// e extraindo o campo "_id" de cada objeto.
  static Future<List<int>> getPictogramIdsByKeyword(String keyword, {String language = "br"}) async {
    List<int> ids = [];
    final encodedKeyword = Uri.encodeComponent(keyword);
    try {
      final response = await _dio.get(
        'https://api.arasaac.org/v1/pictograms/$language/search/$encodedKeyword',
      );
      print("Search status for '$keyword': ${response.statusCode}");
      print("Search response for '$keyword': ${response.data}");
      if (response.statusCode == 200 && response.data is List) {
        // Mapeia cada item para extrair o campo "_id"
        ids = response.data.map<int>((item) => item['_id'] as int).toList();
      }
    } catch (e) {
      print("Erro na busca para '$keyword' [$language]: $e");
    }
    return ids;
  }

  /// Constrói a URL do pictograma a partir do ID.
  static String getPictogramUrlById(int id) {
    return 'https://static.arasaac.org/pictograms/$id/${id}_300.png';
  }

  /// Busca o pictograma por palavra-chave e retorna a URL do primeiro resultado encontrado.
  static Future<String?> getPictogramUrlByKeyword(String keyword, {String language = "br"}) async {
    List<int> ids = await getPictogramIdsByKeyword(keyword, language: language);
    if (ids.isNotEmpty) {
      return getPictogramUrlById(ids.first);
    }
    return null;
  }
}