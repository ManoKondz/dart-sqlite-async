import 'dart:async';
import 'package:sqlite3/sqlite3.dart';

// Classe para gerenciar o banco de dados SQLite
class DatabaseHelper {
  late Database db;

  // Inicializa o banco de dados e cria a tabela se não existir
  Future<void> initializeDB() async {
    db = sqlite3.open('escola.db'); // Banco de dados em um arquivo local
    db.execute(''' 
      CREATE TABLE IF NOT EXISTS TB_ESTUDANTES (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        idade INTEGER NOT NULL
      )
    ''');
  }

  // Fecha o banco de dados
  void closeDB() {
    db.dispose();
  }

  Future<void> dropTable() async {
    db.execute('DROP TABLE IF EXISTS TB_ESTUDANTES');
    print('\nTabela deletada com sucesso!');
  }

  // Insere um novo aluno na tabela
  Future<void> insertAluno(Alunos aluno) async {
    db.execute('INSERT INTO TB_ESTUDANTES (nome, idade) VALUES (?, ?)', [aluno.nome, aluno.idade]);
  }

  // Consulta todos os alunos da tabela
  Future<List<Alunos>> getAlunos() async {
    final result = db.select('SELECT * FROM TB_ESTUDANTES');
    return result.map((row) => Alunos.fromMap(row)).toList();
  }

  // Atualiza os dados de um aluno pelo ID
  Future<void> updateAluno(Alunos aluno) async {
    db.execute('UPDATE TB_ESTUDANTES SET nome = ?, idade = ? WHERE id = ?', [aluno.nome, aluno.idade, aluno.id]);
  }

  // Deleta um aluno pelo ID
  Future<void> deleteAluno(int id) async {
    db.execute('DELETE FROM TB_ESTUDANTES WHERE id = ?', [id]);
  }
}

// Classe Alunos
class Alunos {
  int? id;
  String nome;
  int idade;

  Alunos({this.id, required this.nome, required this.idade});

  // Converte um objeto Alunos para um mapa (para inserir no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
    };
  }

  // Cria um objeto Alunos a partir de um mapa (retorno do banco)
  factory Alunos.fromMap(Map<String, dynamic> map) {
    return Alunos(
      id: map['id'],
      nome: map['nome'],
      idade: map['idade'],
    );
  }
}

// Função principal para testar as operações CRUD
void main() async {
  final dbHelper = DatabaseHelper();
  await dbHelper.initializeDB();

  // Inserindo novos alunos
  print('Inserindo alunos...');
  final aluno1 = Alunos(nome: 'Jojo', idade: 17);
  final aluno2 = Alunos(nome: 'Tatá', idade: 69);
  final aluno3 = Alunos(nome: 'Lulu', idade: 17);

  await dbHelper.insertAluno(aluno1);
  await dbHelper.insertAluno(aluno2);
  await dbHelper.insertAluno(aluno3);

  // Consultando alunos
  print('\nConsultando alunos:');
  List<Alunos> alunos = await dbHelper.getAlunos();
  for (var aluno in alunos) {
    print('ID: ${aluno.id}, Nome: ${aluno.nome}, Idade: ${aluno.idade}');
  }

  // Atualizando um aluno
  print('\nAtualizando aluno com ID 1...');
  final alunoAtualizado1 = Alunos(id: 1, nome: 'Kelwin Jhackson', idade: 19);
  await dbHelper.updateAluno(alunoAtualizado1);

  // Consultando novamente
  print('\nConsultando após atualização:');
  alunos = await dbHelper.getAlunos();
  for (var aluno in alunos) {
    print('ID: ${aluno.id}, Nome: ${aluno.nome}, Idade: ${aluno.idade}');
  }

  // Deletando um aluno
  print('\nDeletando aluno com ID 1...');
  await dbHelper.deleteAluno(1);

  // Consultando após deletar
  print('\nConsultando após exclusão:');
  alunos = await dbHelper.getAlunos();
  for (var aluno in alunos) {
    print('ID: ${aluno.id}, Nome: ${aluno.nome}, Idade: ${aluno.idade}');
  }

  // Deletando a tabela inteira (pra vários testes) 
  print('\nDeletando a tabela inteira...');
  await dbHelper.dropTable();
  dbHelper.closeDB();
}
