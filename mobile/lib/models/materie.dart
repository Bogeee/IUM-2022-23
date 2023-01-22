import 'package:sqflite/sqflite.dart';

class Materia {
  String _nome = '';
  bool _valida = true;

  Materia.fromData(nome, valida) {
    _nome = nome;
    _valida = valida;
  }

  String get nome => _nome;
  bool get valida => _valida;
}

Future<List<String>> getSubjectsFromDB() async {
  final db = await openDatabase('ripetizioni.db');

  final result =
    await db.query('Materie', columns: ["Nome"], where: 'valMateria = ?', whereArgs: ["TRUE"], orderBy: "Nome");

  List<String> materie = [];
  for(var materia in result) {
    materie.add(materia["Nome"] as String);
  }

  return materie;
}