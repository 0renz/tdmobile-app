import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(
    await getDatabasesPath(),
    'dbtarefas.db',
  );

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

  final String tableSql3 =
      'CREATE TABLE contatos('
      'id INTEGER PRIMARY KEY, '
      'nome TEXT, '
      'telefone TEXT, '
      'email TEXT, '
      'relacao TEXT, '
      'endereco TEXT)';

  return openDatabase(
    path,
    version: 2,

    onCreate: (db, version) async {
      await db.execute(tableSql);
      await db.execute(tableSql2);
      await db.execute(tableSql3);

      print('Banco criado com sucesso!');
    },

    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(tableSql2);
        print('Tabela cursos criada!');
      }

      if (oldVersion < 3) {
        await db.execute(tableSql3);
        print('Tabela contatos criada!');
      }
    },

    onDowngrade: onDatabaseDowngradeDelete,
  );
}