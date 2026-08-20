import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CepState();
  }
}

class CepState extends State<Cep> {
  final TextEditingController _cepController = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CEP")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(labelText: "CEP (apenas números"),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(onPressed: _buscaCep, child: Text("Consultar")),
              SizedBox(height: 16.0),
              Text(_resultado,
                style: 
                  TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buscaCep() async {
    final String cep = _cepController.text.trim();
    if (cep.length != 8 || int.tryParse(cep) == null) {
      setState(() {
        _resultado = "Cep Inválido!";
      });
      return;
    }
    final response = await http.get(
      Uri.parse('https://viacep.com.br/ws/$cep/json'),
    );
    if (response.statusCode == 200) {
      // retorno de sucesso
      final jsonresponse = json.decode(response.body);
      if (jsonresponse['erro'] == 'true') {
        setState(() {
          _resultado = 'Erro ao buscar CEP!';
        });
        return;
      }
      setState(() {
        _resultado =
            '''
            CEP: ${jsonresponse['cep']}
            logradouro: ${jsonresponse['logradouro']}
            bairro: ${jsonresponse['bairro']}
            localidade: ${jsonresponse['localidade']}
            uf: ${jsonresponse['uf']}
            ddd: ${jsonresponse['ddd']}           
          ''';
      });
    } else {
      _resultado = 'Erro ao buscar CEP!';
    }
  }
}
