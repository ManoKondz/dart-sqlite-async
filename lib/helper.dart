import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'aluno.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados SQLite
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'escola.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Criação da tabela
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE TB_ALUNOS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        idade INTEGER NOT NULL
      )
    ''');
  }

  // CRUD Operations

  // Inserir dados
  Future<int> insertAluno(Aluno aluno) async {
    final db = await database;
    return await db.insert('TB_ALUNOS', aluno.toMap());
  }

  // Consultar dados
  Future<List<Aluno>> getAlunos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('TB_ALUNOS');
    return List.generate(maps.length, (i) => Aluno.fromMap(maps[i]));
  }

  // Atualizar dados
  Future<int> updateAluno(Aluno aluno) async {
    final db = await database;
    return await db.update(
      'TB_ALUNOS',
      aluno.toMap(),
      where: 'id = ?',
      whereArgs: [aluno.id],
    );
  }

  // Excluir dados
  Future<int> deleteAluno(int id) async {
    final db = await database;
    return await db.delete(
      'TB_ALUNOS',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
