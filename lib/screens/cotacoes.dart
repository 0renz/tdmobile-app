import 'package:flutter/material.dart';
import '../model/cotacao.dart';
import '../services/cotacao_services.dart';

class CotacaoScreen extends StatefulWidget {
  @override
  _CotacaoScreenState createState() => _CotacaoScreenState();
}

class _CotacaoScreenState extends State<CotacaoScreen> {
  final CotacaoService _cotacaoService = CotacaoService();
  DateTime _dataSelecionada = DateTime.now().subtract(const Duration(days: 1));

  // Principais moedas suportadas pelo BCB/BrasilAPI
  final List<Map<String, String>> _moedas = [
    {'codigo': 'USD', 'nome': 'Dólar Americano', 'simbolo': '\$'},
    {'codigo': 'EUR', 'nome': 'Euro', 'simbolo': '€'},
    {'codigo': 'GBP', 'nome': 'Libra Esterlina', 'simbolo': '£'},
    {'codigo': 'JPY', 'nome': 'Iene Japonês', 'simbolo': '¥'},
    {'codigo': 'CHF', 'nome': 'Franco Suíço', 'simbolo': 'CHF'},
    {'codigo': 'CAD', 'nome': 'Dólar Canadense', 'simbolo': 'C\$'},
    {'codigo': 'AUD', 'nome': 'Dólar Australiano', 'simbolo': 'A\$'},
  ];

  late Future<List<Cotacao>> _futureCotacoes;

  @override
  void initState() {
    super.initState();
    _carregarCotacoes();
  }

  String _formatarDataParaApi(DateTime date) {
    final ano = date.year.toString();
    final mes = date.month.toString().padLeft(2, '0');
    final dia = date.day.toString().padLeft(2, '0');

    return '$ano-$mes-$dia';
  }

  void _carregarCotacoes() {
    final dataFormatada = _formatarDataParaApi(_dataSelecionada);

    setState(() {
      _futureCotacoes = Future.wait(
        _moedas.map(
          (m) => _cotacaoService.getCotacao(m['codigo']!, dataFormatada),
        ),
      );
    });
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? selecionada = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selecionada != null && selecionada != _dataSelecionada) {
      setState(() {
        _dataSelecionada = selecionada;
      });
      _carregarCotacoes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataExibicao =
        "${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}/${_dataSelecionada.year}";

    return Scaffold(
      appBar: AppBar(title: Text("Cotação de Moedas"), centerTitle: true),
      body: Column(
        children: [
          // Seletor de Data
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Data: $dataExibicao",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _selecionarData(context),
                  icon: Icon(Icons.edit),
                  label: Text("Alterar"),
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Cotacao>>(
              future: _futureCotacoes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Buscando cotações..."),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 48,
                            color: Colors.orange,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Não foi possível carregar algumas cotações.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Não foi possível obter as cotações para a data selecionada.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _carregarCotacoes,
                            child: Text("Tentar Novamente"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final cotacoes = snapshot.data ?? [];

                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: _moedas.length,
                  itemBuilder: (context, index) {
                    final infoMoeda = _moedas[index];
                    final cotacao = cotacoes.firstWhere(
                      (c) => c.moeda == infoMoeda['codigo'],
                      orElse: () => Cotacao(
                        moeda: infoMoeda['codigo']!,
                        data: '',
                        valor: 0.0,
                      ),
                    );

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          child: Text(
                            infoMoeda['simbolo']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        title: Text(
                          infoMoeda['nome']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text("${infoMoeda['codigo']} / BRL"),
                        trailing: Text(
                          "R\$ ${cotacao.valor.toStringAsFixed(4)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
