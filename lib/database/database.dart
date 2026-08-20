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

  final String tableSql2 = 
      'CREATE TABLE cursos('
      'id INTEGER PRIMARY KEY, '
      'nome TEXT, '
      'totalHoras INTEGER)';

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(tableSql);
      print('criando tabela $tableSql');
    },
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion == 2) {
        db.execute(tableSql2);
        print('atualizando tabela $tableSql2');
      }
    },
    onDowngrade: onDatabaseDowngradeDelete,
    version: 1,
  );
}
