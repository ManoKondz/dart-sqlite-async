import 'package:flutter/material.dart';
import 'helper.dart';
import 'aluno.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dart com SQLite')),
        body: FutureBuilder<List<Aluno>>(
          future: dbHelper.getAlunos(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final alunos = snapshot.data!;
            return ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aluno = alunos[index];
                return ListTile(
                  title: Text(aluno.nome),
                  subtitle: Text('Idade: ${aluno.idade}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await dbHelper.deleteAluno(aluno.id!);
                      (context as Element).reassemble();
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await dbHelper.insertAluno(Aluno(nome: 'Novo Aluno', idade: 20));
            // Recarrega a tela
            (context as Element).reassemble();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
