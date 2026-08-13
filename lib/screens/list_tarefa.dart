import 'package:flutter/material.dart';
import '../model/tarefa.dart';
import 'form_tarefa.dart';
import '../database/tarefaDao.dart';

class ListaTarefas extends StatefulWidget {
  @override
  State<ListaTarefas> createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  TarefaDao dao = TarefaDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Tarefas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future future = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormTarefa();
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
      body: FutureBuilder<List<Tarefa>>(
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
                return Center(
                  child: Text('Erro ao carregar as tarefas'),
                );
              }
              List<Tarefa>? _tarefas = snapshot.data;
              return ListView.builder(
                itemCount: _tarefas!.length,
                itemBuilder: (context, index) {
                  final tarefa = _tarefas[index];
                  return _itemTarefa(context, tarefa);
                },
              );
          }
        },
      ),
    );
  }

  Widget _itemTarefa(BuildContext context, Tarefa tarefa) {
    final bool isChecked = tarefa.status == 1;

    return GestureDetector(
      onTap: () {
        final Future future = Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return FormTarefa(tarefa: tarefa);
            },
          ),
        );
        future.then((p) {
          setState(() {});
        });
      },
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: isChecked,
            checkColor: Colors.white,
            activeColor: Colors.green,
            onChanged: (bool? value) {
              _atualizar(tarefa, value == true ? 1 : 0);
            },
          ),
          title: Text(tarefa.descricao),
          subtitle: Text(tarefa.obs),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _confirmarExclusao(context, tarefa.id);
                },
                child: Icon(Icons.remove_circle, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _atualizar(Tarefa tarefa, int status) {
    Tarefa t = Tarefa(tarefa.id, status, tarefa.descricao, tarefa.obs);
    dao.update(t).then((value) => setState(() {}));
  }

  void _excluir(int id) {
    dao.delete(id).then((value) => setState((){}));
  }

  void _confirmarExclusao(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Deseja realmente excluir esta tarefa?'),
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
