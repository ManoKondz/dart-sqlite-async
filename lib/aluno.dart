class Aluno {
  int? id;
  String nome;
  int idade;

  Aluno({this.id, required this.nome, required this.idade});

  // Converte o objeto para um mapa (Map<String, dynamic>)
  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'idade': idade};
  }

  // Cria um objeto Aluno a partir de um mapa
  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      nome: map['nome'],
      idade: map['idade'],
    );
  }
}
