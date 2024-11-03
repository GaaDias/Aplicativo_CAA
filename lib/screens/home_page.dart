import 'package:flutter/material.dart';
import '../models/cards.dart';
import '../widgets/cards_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Futuramente trocar os Icons pelas imagens do Arasaac
  final List<Cards> buttons = [
    Cards("sim", Colors.green, Icons.thumb_up_alt_sharp),
    Cards("eu", Colors.yellow, Icons.person),
    Cards("preciso", Colors.pink, Icons.pan_tool),
    Cards("banheiro", Colors.blue, Icons.bathroom),
    Cards("não", Colors.green, Icons.thumb_down),
    Cards("você", Colors.yellow, Icons.person_outline),
    Cards("tenho", Colors.pink, Icons.accessibility_new),
    Cards("comer", Colors.blue, Icons.sentiment_satisfied),
    Cards("não sei", Colors.green, Icons.person_2),
    Cards("nós", Colors.yellow, Icons.person_pin),
    Cards("quero", Colors.pink, Icons.back_hand),
    Cards("brincar", Colors.blue, Icons.play_circle)
  ];

  List<String> selectedWords = [];

  void addWord(String word) {
    setState(() {
      selectedWords.add(word);
    });
  }

  void clearWords() {
    setState(() {
      selectedWords.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            height: 50,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                selectedWords.join(" "),
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: clearWords,
            child: Text("Limpar"),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                return CardsWidget(
                  button: buttons[index],
                  onTap: () => addWord(buttons[index].label),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
