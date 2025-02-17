import 'dart:isolate';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../data/database_helper.dart';

void _downloadPictogram(Map<String, dynamic> args) async {
  final String pictogramName = args['name'];
  final String url = args['url'];
  final SendPort sendPort = args['sendPort'];

  try {
    final directory = await getApplicationDocumentsDirectory();
    final localDir = Directory('${directory.path}/pictograms');
    if (!await localDir.exists()) {
      await localDir.create(recursive: true);
    }
    final savePath = '${localDir.path}/$pictogramName.png';

    final dio = Dio();
    final response = await dio.download(url, savePath);
    if (response.statusCode == 200) {
      // Atualiza o banco com o caminho local (assumindo que "name" é o identificador)
      await DatabaseHelper.insertPictogram({
        'name': pictogramName.toLowerCase(),
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
  static Future<void> checkAndDownloadPictogram(String pictogramName, String url) async {
    // Verifica se já existe o pictograma localmente
    final localPath = await DatabaseHelper.getPictogramLocalPath(pictogramName);
    if (localPath != null && localPath.isNotEmpty) {
      return;
    }

    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_downloadPictogram, {
      'name': pictogramName,
      'url': url,
      'sendPort': receivePort.sendPort,
    });

    await for (var message in receivePort) {
      if (message == true) {
        print("Pictograma '$pictogramName' baixado com sucesso.");
      } else {
        print("Falha ao baixar pictograma '$pictogramName'.");
      }
      receivePort.close();
      break;
    }
  }
}