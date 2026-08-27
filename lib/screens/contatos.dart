import 'package:flutter/material.dart';
import '../model/contato.dart';
import 'form_contato.dart';
import '../database/contatoDao.dart';

class Contatos extends StatefulWidget {
  @override
  State<Contatos> createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  ContatoDao dao = ContatoDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contatos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future future = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormContato();
              },
            ),
          );
          future.then((p) {
            setState(() {
              // atualiza o estado da tela (executa o build)
            });
          });
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Contato>>(
        initialData: [],
        future: dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text('Não foi possível conectar ao banco de dados'),
              );
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar contatos'));
              }
              List<Contato>? _contatos = snapshot.data;
              if (_contatos == null) {
                return Center(child: Text('Nenhum contato encontrado'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.85,
                ),
                itemCount: _contatos!.length,
                itemBuilder: (context, index) {
                  final contato = _contatos[index];
                  return _itemContato(context, contato);
                },
              );
          }
        },
      ),
    );
  }

  Widget _itemContato(BuildContext context, Contato contato) {
    return Card(

      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final Future future = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormContato(contato: contato);
              },
            ),
          );

          future.then((p) {
            setState(() {});
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmarExclusao(context, contato.id);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                contato.nome,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  const Icon(Icons.phone, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      contato.telefone,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.email, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(contato.email, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.import_contacts_rounded, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(contato.relacao, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.home, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      contato.endereco,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _excluir(int id) {
    dao.delete(id).then((value) => setState(() {}));
  }

  void _confirmarExclusao(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Deseja realmente excluir este contato?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                _excluir(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
