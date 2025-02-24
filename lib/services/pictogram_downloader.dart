import 'dart:isolate';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../data/database_helper.dart';

/// Essa função será executada dentro do isolate.
/// Ela recebe o caminho do diretório local já calculado no main isolate.
void _downloadPictogram(Map<String, dynamic> args) async {
  final String pictogramIdStr = args['pictogramId']; // ID do pictograma em formato de String
  final String url = args['url'];
  final String localDirPath = args['localDirPath']; // Caminho já obtido fora do isolate
  final SendPort sendPort = args['sendPort'];

  try {
    final Directory localDir = Directory(localDirPath);
    if (!await localDir.exists()) {
      await localDir.create(recursive: true);
    }
    final String savePath = '$localDirPath/$pictogramIdStr.png';
    
    final Dio dio = Dio();
    final response = await dio.download(url, savePath);
    if (response.statusCode == 200) {
      // Atualiza o banco de dados com o pictograma baixado.
      await DatabaseHelper.insertPictogram({
        'id': int.parse(pictogramIdStr), // Utiliza o ID numérico
        'local_path': savePath,
        'online_url': url,
      });
      sendPort.send(true);
    } else {
      sendPort.send(false);
    }
  } catch (e) {
    print("Erro ao baixar pictograma: $e");
    sendPort.send(false);
  }
}

class PictogramDownloader {
  /// Verifica se o pictograma (identificado pelo id) já foi salvo; 
  /// se não, obtém o caminho do diretório local, passa ao isolate e inicia o download.
  static Future<void> checkAndDownloadPictogram(String pictogramIdStr, String url) async {
    // Primeiro, verifique se já existe no banco (usando o ID)
    final localPath = await DatabaseHelper.getPictogramLocalPathById(int.parse(pictogramIdStr));
    if (localPath != null && localPath.isNotEmpty) {
      return;
    }

    // Obtenha o caminho do diretório de documentos no main isolate
    final Directory directory = await getApplicationDocumentsDirectory();
    final String localDirPath = '${directory.path}/pictograms';

    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_downloadPictogram, {
      'pictogramId': pictogramIdStr,
      'url': url,
      'localDirPath': localDirPath,
      'sendPort': receivePort.sendPort,
    });

    // Aguarda o retorno do isolate
    await for (var message in receivePort) {
      if (message == true) {
        print("Pictograma '$pictogramIdStr' baixado com sucesso.");
      } else {
        print("Falha ao baixar pictograma '$pictogramIdStr'.");
      }
      receivePort.close();
      break;
    }
  }
}
