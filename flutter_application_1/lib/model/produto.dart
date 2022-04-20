final String tableProdutos = 'produtos';

class ProdutoFields {
  static String id = 'id';
  static String nome = 'nome';
  static String valor = 'valor';
}

class Produto {
  final int id;
  late final String nome;
  final num valor;
  Produto({required this.id, required this.nome, required this.valor});

  Map<String, Object?> toJson() => {
        ProdutoFields.id: id,
        ProdutoFields.nome: nome,
        ProdutoFields.valor: valor
      };

  static Produto fromJson(Map<String, Object?> json) {
    return Produto(
        id: json[ProdutoFields.id] as int,
        nome: json[ProdutoFields.nome].toString(),
        valor: json[ProdutoFields.valor] as num);
  }
}
