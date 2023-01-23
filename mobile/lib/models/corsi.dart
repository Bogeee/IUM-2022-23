import 'package:proj/models/docenti.dart';
import 'package:proj/models/materie.dart';
import 'package:sqflite/sqflite.dart';

class Corso {
  int _id = 0;
  late Docente _docente;
  late Materia _materia;
  bool _valido = true;

  Corso.fromData(id, docente, materia, valido) {
    _id = id;
    _docente = docente;
    _materia = materia;
    _valido = valido;
  }

  int get id => _id;
  Docente get docente => _docente;
  Materia get materia => _materia;
  bool get valido => _valido;
}

Future<List<Materia>> getSubjectForStudent(int studentId) async {
  final db = await openDatabase('ripetizioni.db');
  List<Materia> subjects = [];

  final result = await db.rawQuery("SELECT DISTINCT C.Materia "
      "FROM Corsi AS C INNER JOIN Prenotazioni AS P "
      "ON P.Corso = C.ID "
      "INNER JOIN Materie AS M "
          "ON M.Nome = C.Materia "
      "WHERE P.Studente = ? AND P.Stato <> 2 AND M.valMateria = 'TRUE' "
      "ORDER BY Materia;",
      [studentId]
  );

  if(result.isEmpty) {
    return subjects;
  }

  Materia m;

  result.forEach((row) {
    m = Materia.fromData(
      row["Materia"], true
      );

    subjects.add(m);
  });

  return subjects;
}