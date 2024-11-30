import 'dart:collection';

class PictogramDatabase {
  static final Map<String, List<String>> _pictogramKeywords = {
    'assets/pictograms/abacaxi.png': ['abacaxi', 'fruta', 'alimento', 'comida'],
    'assets/pictograms/alface.png': ['alface', 'vegetal', 'salada', 'verdura', 'comida'],
    'assets/pictograms/amendoas.png': ['amêndoas', 'nozes', 'castanha', 'snack', 'comida'],
    'assets/pictograms/banheiro.png': ['banheiro', 'higiene', 'privada', 'toalete', 'sanitário'],
    'assets/pictograms/batatas_fritas.png': ['batatas fritas', 'batatas', 'snack', 'comida', 'fritas'],
    'assets/pictograms/beringela.png': ['beringela', 'vegetal', 'comida', 'verdura'],
    'assets/pictograms/brincar.png': ['brincar', 'jogar', 'diversão', 'atividade', 'criança'],
    'assets/pictograms/brincar_bola.png': ['brincar bola', 'bola', 'esporte', 'jogar', 'diversão'],
    'assets/pictograms/cenoura.png': ['cenoura', 'vegetal', 'verdura', 'comida', 'salada'],
    'assets/pictograms/chocolate.png': ['chocolate', 'doce', 'comida', 'sobremesa'],
    'assets/pictograms/chocolates.png': ['chocolates', 'doces', 'comida', 'sobremesa'],
    'assets/pictograms/comer_mesa.png': ['comer', 'mesa', 'refeição', 'alimentação'],
    'assets/pictograms/comer_um_sanduiche.png': ['comer sanduíche', 'sanduíche', 'almoço', 'lanches', 'comida'],
    'assets/pictograms/comer.png': ['comer', 'alimentar', 'refeição', 'jantar', 'almoço'],
    'assets/pictograms/comida_pessoas.png': ['comida pessoas', 'família', 'jantar', 'refeição', 'comida'],
    'assets/pictograms/comida.png': ['comida', 'alimento', 'refeição', 'almoço', 'jantar'],
    'assets/pictograms/coxa_de_frango.png': ['coxa de frango', 'frango', 'carne', 'comida'],
    'assets/pictograms/donut.png': ['donut', 'rosquinha', 'doce', 'sobremesa', 'comida'],
    'assets/pictograms/eu_menina.png': ['eu menina', 'menina', 'criança', 'pessoa'],
    'assets/pictograms/eu_mulher.png': ['eu mulher', 'mulher', 'adulta', 'pessoa'],
    'assets/pictograms/eu_homem.png': ['eu homem', 'homem', 'adulto', 'pessoa'],
    'assets/pictograms/eu.png': ['eu', 'pessoa', 'individual', 'autorreferência'],
    'assets/pictograms/melancia.png': ['melancia', 'fruta', 'comida', 'alimento'],
    'assets/pictograms/nao_menina.png': ['nao menina', 'nao', 'menina', 'negaçao', 'criança'],
    'assets/pictograms/nao_quero.png': ['nao quero', 'nao', 'negaçao', 'recusa'],
    'assets/pictograms/nao.png': ['nao', 'negaçao', 'recusar', 'proibiçao'],
    'assets/pictograms/pessego.png': ['pêssego', 'fruta', 'comida', 'alimento'],
    'assets/pictograms/quero_mais.png': ['quero mais', 'quero', 'mais', 'adicionar', 'aumentar'],
    'assets/pictograms/quero.png': ['quero', 'desejo', 'sim', 'aceitar'],
    'assets/pictograms/salsichas.png': ['salsichas', 'carne', 'comida', 'alimento'],
  };

  /// Retorna o caminho do pictograma correspondente à palavra-chave.
  static String? getPictogramByKeyword(String keyword) {
    for (var entry in _pictogramKeywords.entries) {
      if (entry.value.contains(keyword.toLowerCase())) {
        return entry.key;
      }
    }
    return null; // Caso nenhuma palavra-chave corresponda.
  }

  /// Retorna todos os pictogramas associados à palavra-chave.
  static List<String> getAllPictogramsForKeyword(String keyword) {
    final entry = _pictogramKeywords.entries.firstWhere(
      (element) =>
          element.value.contains(keyword.toLowerCase().trim()),
      orElse: () => MapEntry("", []),
    );
    return entry.key.isNotEmpty ? _pictogramKeywords[entry.key]! : [];
  }

  /// Retorna todos os pictogramas do banco de dados.
  static List<String> getAllPictograms() {
    return UnmodifiableListView(
      _pictogramKeywords.keys.toList(),
    );
  }
}
