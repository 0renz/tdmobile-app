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
  
  Map<String, dynamic>? _dadosCep;
  String? _mensagemErro;
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consulta de CEP"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: "CEP (apenas números)",
                hintText: "Ex: 01001000",
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: _carregando ? null : _buscaCep,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: _carregando
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text("Consultar", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 24.0),
            _construirResultado(),
          ],
        ),
      ),
    );
  }

  Widget _construirResultado() {
    if (_mensagemErro != null) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 12),
            Text(
              _mensagemErro!,
              style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    if (_dadosCep == null) {
      return Container();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(Icons.home, color: Theme.of(context).primaryColor),
              ),
              title: Text(
                _dadosCep!['logradouro'].isEmpty 
                    ? 'Logradouro não informado' 
                    : _dadosCep!['logradouro'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text("CEP: ${_dadosCep!['cep']}"),
            ),
            Divider(height: 24),
            _itemInfo(Icons.map_outlined, "Bairro", _dadosCep!['bairro']),
            _itemInfo(Icons.location_city, "Cidade / UF", "${_dadosCep!['localidade']} - ${_dadosCep!['uf']}"),
            _itemInfo(Icons.phone_android, "DDD", "DDD ${_dadosCep!['ddd']}"),
          ],
        ),
      ),
    );
  }

  Widget _itemInfo(IconData icon, String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          SizedBox(width: 12),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
          Expanded(
            child: Text(
              valor.isEmpty ? '-' : valor,
              style: TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buscaCep() async {
    final String cep = _cepController.text.trim();

    if (cep.length != 8 || int.tryParse(cep) == null) {
      setState(() {
        _mensagemErro = "CEP inválido! Digite 8 números.";
        _dadosCep = null;
      });
      return;
    }

    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json'),
      );

      if (response.statusCode == 200) {
        final jsonresponse = json.decode(response.body);

        // O ViaCEP retorna um boolean no campo erro, não uma String 'true'
        if (jsonresponse['erro'] == true) {
          setState(() {
            _mensagemErro = 'CEP não encontrado!';
            _dadosCep = null;
          });
        } else {
          setState(() {
            _dadosCep = jsonresponse;
            _mensagemErro = null;
          });
        }
      } else {
        setState(() {
          _mensagemErro = 'Erro de conexão com o servidor!';
          _dadosCep = null;
        });
      }
    } catch (e) {
      setState(() {
        _mensagemErro = 'Falha ao buscar CEP. Verifique a internet.';
        _dadosCep = null;
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }
}