class Cotacao {
  final String moeda;
  final String data;
  final double valor;

  Cotacao({required this.moeda, required this.data, required this.valor});

  factory Cotacao.fromJson(
    Map<String, dynamic> json,
    String moedaParam,
    String dataParam,
  ) {
    final valor = json['cotacao_venda'];

    if (valor == null) {
      throw Exception('Cotação de venda não encontrada.');
    }

    return Cotacao(
      moeda: moedaParam,
      data: json['data_hora_cotacao'] ?? dataParam,
      valor: (valor as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Cotacao{moeda: $moeda, data: $data, valor: $valor}';
  }
}
