import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/feriado.dart';

class FeriadoService {
  final String apiUrl = 'https://brasilapi.com.br/api/feriados/v1/';

  Future<List<Feriado>> getFeriados(int ano) async {
    final response = await http.get(Uri.parse(apiUrl + ano.toString()));

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => Feriado.fromJson(e))
          .toList();
    } else {
      throw Exception('Falha ao carregar feriados');
    }
  }
}