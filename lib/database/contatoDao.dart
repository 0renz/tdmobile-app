import 'package:sqflite/sqflite.dart';
import '../model/contato.dart';
import 'database.dart';

class ContatoDao {
  final String _tableName = "contatos";

  // converter objeto para map
  Map<String, dynamic> toMap(Contato contato) {
    final Map<String, dynamic> contatoMap = Map();
    contatoMap['nome'] = contato.nome;
    contatoMap['telefone'] = contato.telefone;
    contatoMap['email'] = contato.email;
    contatoMap['relacao'] = contato.relacao;
    contatoMap['endereco'] = contato.endereco;
    return contatoMap;
  }

  List<Contato> toList(List<Map<String, dynamic>> result) {
    final List<Contato> contatos = [];
    for (Map<String, dynamic> row in result) {
      Contato contato = Contato(
        row['id'],
        row['nome'],
        row['telefone'],
        row['email'],
        row['relacao'],
        row['endereco'],
      );
      contatos.add(contato);
    }
    return contatos;
  }

  Future<int> add(Contato contato) async {
    Database db = await getDatabase();
    Map<String, dynamic> contatoMap = toMap(contato);
    print("Teste add");
    return db.insert(_tableName, contatoMap);
  }

  Future<int> update(Contato contato) async {
    Database db = await getDatabase();
    Map<String, dynamic> contatoMap = toMap(contato);
    return db.update(
      _tableName,
      contatoMap,
      where: 'id = ?',
      whereArgs: [contato.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await getDatabase();
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Contato>> findAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contato> contatos = toList(result);
    return contatos;
  }
}
