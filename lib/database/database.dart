import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'dbtarefas.db');

  final String tableSql =
      'CREATE TABLE tarefas('
      'id INTEGER PRIMARY KEY, '
      'status INTEGER, '
      'descricao TEXT, '
      'obs TEXT)';

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(tableSql);
      print('criando tabela $tableSql');
    },
    version: 1,
  );
}
