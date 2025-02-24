import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileListScreen extends StatefulWidget {
  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  List<FileSystemEntity> files = [];
  bool isLoading = true;

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
        files = pictogramsDir.listSync();
        isLoading = false;
      });
    } else {
      setState(() {
        files = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pictogramas Baixados")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                final fileName = file.path.split(Platform.pathSeparator).last;
                return ListTile(
                  title: Text(fileName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: Text("Visualização")),
                          body: Center(child: Image.file(File(file.path))),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
