import 'package:flutter/material.dart';
import '../model/contato.dart';
import '../components/editor.dart';
import '../database/contatoDao.dart';

class FormContato extends StatefulWidget {
  final Contato? contato; // receber um parametro contato opcionalmente
  const FormContato({super.key, this.contato});

  @override
  State<StatefulWidget> createState() {
    return _FormContatoState();
  }
}

class _FormContatoState extends State<FormContato> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorTelefone = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorRelacao = TextEditingController();
  final TextEditingController _controladorEndereco = TextEditingController();
  
  int? _id; // _ = so pode ser acessada dentro da propria classe
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contato')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            criarContato(context);
          }
        },
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Editor(
                _controladorNome,
                'Nome',
                'Informe o nome do contato',
                Icons.person,
              ),
              Editor(
                _controladorTelefone,
                'Telefone',
                'Informe o telefone do contato',
                Icons.phone,
              ),
              Editor(
                _controladorEmail,
                'Email',
                'Informe o email do contato',
                Icons.email,
              ),
              Editor(
                _controladorRelacao,
                'Relação',
                'Informe a relação com o contato',
                Icons.account_circle,
              ),
              Editor(
                _controladorEndereco,
                'Endereço',
                'Informe o endereço do contato',
                Icons.home,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void criarContato(BuildContext context) {
    ContatoDao dao = ContatoDao();
    String mensagem = "Contato criado com sucesso!";
    if (_id != null) {
      final contatoCriado = Contato(
        _id!,
        _controladorNome.text,
        _controladorTelefone.text,
        _controladorEmail.text,
        _controladorRelacao.text,
        _controladorEndereco.text,
      );
      dao.update(contatoCriado);
      mensagem = "Contato atualizado com sucesso!";
    } else {
      final contatoCriado = Contato(
        0,
        _controladorNome.text,
        _controladorTelefone.text,
        _controladorEmail.text,
        _controladorRelacao.text,
        _controladorEndereco.text,
      );
      dao.add(contatoCriado);
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      _id = widget.contato!.id;
      _controladorNome.text = widget.contato!.nome;
      _controladorTelefone.text = widget.contato!.telefone;
      _controladorEmail.text = widget.contato!.email;
      _controladorRelacao.text = widget.contato!.relacao;
      _controladorEndereco.text = widget.contato!.endereco;
    }
  }
}
