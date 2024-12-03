import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final int currentColumns;
  final Function(int) onColumnsChanged;

  const Settings({
    Key? key,
    required this.currentColumns,
    required this.onColumnsChanged,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late int _selectedColumn;

  @override
  void initState() {
    super.initState();
    _selectedColumn = widget.currentColumns; // Inicializa com o valor atual
  }

  void _updateColumns(int value) {
    setState(() {
      _selectedColumn = value;
    });
    widget.onColumnsChanged(value); // Notifica a mudança
  }

  void _navigateToHome() {
    Navigator.popUntil(
      context,
      (route) => route.isFirst, // Volta até a primeira tela na pilha (HomePage)
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C4C4C),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leadingWidth: 150,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*IconButton(
              icon: const Icon(Icons.menu),
              onPressed: (){

              },
              tooltip: 'Menu',
            ),*/
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                _navigateToHome();
              },
              tooltip: 'Home',
            ),
          ],
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Selecione o número de colunas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: List.generate(9, (index) {
                  int value = index + 2; // Valores de 2 a 10
                  bool isSelected = value == _selectedColumn;

                  return GestureDetector(
                    onTap: () => _updateColumns(value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.shade900
                            : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey.shade400,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$value',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: List.generate(9, (index) {
                  int value = index + 11; // Valores de 11 a 18
                  bool isSelected = value == _selectedColumn;

                  return GestureDetector(
                    onTap: () => _updateColumns(value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.shade900
                            : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey.shade400,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$value',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}