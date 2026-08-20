import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/feriado.dart';
import 'package:flutter_application_1/services/feriado_services.dart';
import 'package:intl/intl.dart';

class Feriados extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeriadosState();
  }
}

class _FeriadosState extends State<Feriados> {
  final FeriadoService _feriadoService = FeriadoService();
  TextEditingController _anoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Future<List<Feriado>> _feriados;
  int _ano = DateTime.now().year;
  @override
  void initState() {
    super.initState();
    _anoController.text = _ano.toString();
    _feriados = _feriadoService.getFeriados(_ano);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feriados Nacionais')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _anoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Ano'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um ano';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _ano = int.parse(_anoController.text);
                          _feriados = _feriadoService.getFeriados(_ano);
                        });
                      }
                    },
                    child: Text('Buscar'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Feriado>>(
              future: _feriados,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar feriados'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum feriado encontrado'));
                } else {
                  final feriados = snapshot.data!;
                  return ListView.builder(
                    itemCount: feriados.length,
                    itemBuilder: (context, index) {
                      final feriado = feriados[index];
                      return ListTile(
                        leading: Icon(Icons.event),
                        title: Text(feriado.name),
                        subtitle: Text(
                          DateFormat(
                            'dd/MM/yyyy',
                          ).format(DateTime.parse(feriado.date)),
                        ),
                        trailing: Text(feriado.type),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
