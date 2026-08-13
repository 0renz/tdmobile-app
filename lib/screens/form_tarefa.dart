import 'package:flutter/material.dart';
import '../model/tarefa.dart';
import '../components/editor.dart';
import '../database/tarefaDao.dart';

class FormTarefa extends StatefulWidget {
  final Tarefa? tarefa; // receber um parametro tarefa opcionalmente
  const FormTarefa({super.key, this.tarefa});

  @override
  State<StatefulWidget> createState() {
    return _FormTarefaState();
  }
}

class _FormTarefaState extends State<FormTarefa> {
  final TextEditingController _controladorDescricao = TextEditingController();
  final TextEditingController _controladorObservacao = TextEditingController();
  int? _id; // _ = so pode ser acessada dentro da propria classe
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Tarefa!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            criarTarefa(context);
          }
        },
        child: const Icon(Icons.save),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Editor(
              _controladorDescricao,
              'Descrição',
              'Informe a descrição da tarefa',
              Icons.description,
            ),
            Editor(
              _controladorObservacao,
              'Observação',
              'Informe a observação da tarefa',
              Icons.add_card_sharp,
            ),
          ],
        ),
      ),
    );
  }

  void criarTarefa(BuildContext context) {
    TarefaDao dao = TarefaDao();
    String mensagem = "Tarefa criada com sucesso!";
    if (_id != null) {
      final tarefaCriada = Tarefa(
        _id!,
        widget.tarefa!.status,
        _controladorDescricao.text,
        _controladorObservacao.text,
      );
      dao.update(tarefaCriada);
      mensagem = "Tarefa atualizada com sucesso!";
    } else {
      final tarefaCriada = Tarefa(
        0,
        0,
        _controladorDescricao.text,
        _controladorObservacao.text,
      );
      dao.add(tarefaCriada);
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _id = widget.tarefa!.id;
      _controladorDescricao.text = widget.tarefa!.descricao;
      _controladorObservacao.text = widget.tarefa!.obs;
    }
  }
}
