import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileListScreen extends StatefulWidget {
  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final pictogramsDir = Directory('${directory.path}/pictograms');
    if (await pictogramsDir.exists()) {
      setState(() {
        _files = pictogramsDir.listSync();
        _isLoading = false;
      });
    } else {
      setState(() {
        _files = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arquivos Baixados"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                final fileName = file.path.split(Platform.pathSeparator).last;
                return ListTile(
                  title: Text(fileName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImageViewScreen(file: file),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  final FileSystemEntity file;
  const ImageViewScreen({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visualizar Imagem")),
      body: Center(
        child: Image.file(File(file.path)),
      ),
    );
  }
}
