import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/cotacao.dart';

class CotacaoService {
  final String baseUrl =
      'https://brasilapi.com.br/api/cambio/v1/cotacao';

  Future<Cotacao> getCotacao(
    String moeda,
    String data,
  ) async {
    final url = '$baseUrl/$moeda/$data';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao carregar cotação para $moeda. '
        'Status: ${response.statusCode}',
      );
    }

    final jsonResponse = json.decode(response.body);

    if (jsonResponse is! Map<String, dynamic>) {
      throw Exception('Formato de resposta inesperado.');
    }

    final cotacoes = jsonResponse['cotacoes'];

    if (cotacoes is! List || cotacoes.isEmpty) {
      throw Exception(
        'Nenhuma cotação encontrada para $moeda em $data.',
      );
    }

    // Última cotação do dia
    final ultimaCotacao = cotacoes.last;

    return Cotacao.fromJson(
      ultimaCotacao,
      moeda,
      jsonResponse['data'] ?? data,
    );
  }
}