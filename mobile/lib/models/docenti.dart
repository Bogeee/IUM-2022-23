import 'package:sqflite/sqflite.dart';

class Docente {
  int _id = 0;
  String _nome = '';
  String _cognome = '';
  String _email = '';
  bool _valido = true;

  Docente.fromData(id, nome, cognome, email, valido) {
    _id = id;
    _nome = nome;
    _cognome = cognome;
    _email = email;
    _valido = _valido;
  }

  int get id => _id;
  String get nome => _nome;
  String get cognome => _cognome;
  String get email => _email;
  bool get valido => _valido;
}

Future<List<Docente>> getProfessorBySubject(String subject) async {
  final db = await openDatabase('ripetizioni.db');
  List<Docente> professors = [];

  final result = await db.rawQuery("SELECT D.* "
      "FROM Corsi AS C INNER JOIN Docenti AS D ON D.ID = C.Docente "
      "WHERE C.Materia = ? AND D.valDocente = 'TRUE' AND C.valCorso = 'TRUE' "
      "ORDER BY D.Cognome, D.Nome;",
      [subject]
  );

  if (result.isEmpty) {
    return professors;
  }

  Docente d;

  result.forEach((row) {
    d = Docente.fromData(
        row['ID'] as int,
        row['Nome'].toString(),
        row['Cognome'].toString(),
        row['Email'].toString(),
        row['valDocente'] == 'TRUE' ? true : false
    );

    professors.add(d);
  });

  return professors;
}