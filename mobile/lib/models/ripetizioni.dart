import 'package:sqflite/sqflite.dart';

// models
import 'package:proj/models/docenti.dart';
import 'package:proj/models/materie.dart';
import 'package:proj/models/corsi.dart';

class Ripetizione {
  late Corso _corso;
  String _giorno = '';
  int _studente = 0;
  int _oraI = 0;
  int _oraF = 0;
  int _stato = 0;
  String _argomento = '';

  Ripetizione.fromData(corso, giorno, studente, oraI, oraF, stato, argomento) {
    _corso = corso;
    _giorno = giorno;
    _studente = studente;
    _oraI = oraI;
    _oraF = oraF;
    _stato = stato;
    _argomento = argomento;
  }

  Corso get corso => _corso;
  String get giorno => _giorno;
  int get studente => _studente;
  int get oraI => _oraI;
  int get oraF => _oraF;
  int get stato => _stato;
  String get argomento => _argomento;
}

class LezioniSettimanali {
  String _giorno = '';
  int _numero = 0;

  LezioniSettimanali(this._giorno);

  LezioniSettimanali.fromData(giorno, numero){
    _giorno = giorno;
    _numero = numero;
  }

  String get giorno => _giorno;
  int get numero => _numero;

  set numLezioni(int n){
    _numero = n;
  }
}

Future<List<LezioniSettimanali>> getWeeklyLessons(int userId) async {
  final db = await openDatabase('ripetizioni.db');
  List<LezioniSettimanali> lessonsEachDay = [];

  final result = await db.query(
    'Prenotazioni', 
    columns: ['Giorno', 'COUNT(*) AS Numero'],
    where: 'Studente = ? AND Stato < 2',
    whereArgs: [userId],
    groupBy: 'Giorno',
    orderBy: 'Giorno'
  );

  if(result.isEmpty){
    return lessonsEachDay;
  }

  LezioniSettimanali lun = LezioniSettimanali('Lunedì');
  LezioniSettimanali mar = LezioniSettimanali('Martedì');
  LezioniSettimanali mer = LezioniSettimanali('Mercoledì');
  LezioniSettimanali gio = LezioniSettimanali('Giovedì');
  LezioniSettimanali ven = LezioniSettimanali('Venerdì');

  for(int i = 0; i < result.length; i++){
    switch(result[i]['Giorno']){
      case 'Lunedì':
        lun.numLezioni = result[i]['Numero'] as int;
        break;
      case 'Martedì':
        mar.numLezioni = result[i]['Numero'] as int;
        break;
      case 'Mercoledì':
        mer.numLezioni = result[i]['Numero'] as int;
        break;
      case 'Giovedì':
        gio.numLezioni = result[i]['Numero'] as int;
        break;
      case 'Venerdì':
        ven.numLezioni = result[i]['Numero'] as int;
        break;
    }
  }

  lessonsEachDay.add(lun);
  lessonsEachDay.add(mar);
  lessonsEachDay.add(mer);
  lessonsEachDay.add(gio);
  lessonsEachDay.add(ven);
  
  return lessonsEachDay;
}

Future<List<Ripetizione>> getTodaysLessons(int userId) async {
  final db = await openDatabase('ripetizioni.db');
  List<Ripetizione> lessonsToday = [];

  final result = await db.rawQuery(
    "SELECT Prenotazioni.*, Corsi.*, Docenti.* "
    "FROM Prenotazioni "
    "INNER JOIN Corsi "
        "ON Prenotazioni.Corso = Corsi.ID "
    "INNER JOIN Docenti "
        "ON Corsi.Docente = Docenti.ID "
    "WHERE Prenotazioni.Giorno = ? "
        "AND Prenotazioni.Studente = ? "
        "AND Prenotazioni.Stato < 2",
    ['Mercoledì', userId]
  );

  if (result.isEmpty) {
    return lessonsToday;
  }

  Docente d;
  Materia m;
  Corso c;
  Ripetizione r;

  result.forEach((row) { 
    d = Docente.fromData(
      row['Docente'] as int, 
      row['Nome'].toString(), 
      row['Cognome'].toString(), 
      row['Email'].toString(), 
      row['valDocente'] == 'TRUE' ? true : false
    );
    m = Materia.fromData(row['Materia'] as String, true);
    c = Corso.fromData(
      row['Corso'] as int, 
      d, 
      m, 
      row['valCorso'] == 'TRUE' ? true : false
    );
    r = Ripetizione.fromData(
      c, 
      row['Giorno'].toString(), 
      userId, 
      row['OraI'] as int, 
      row['OraF'] as int, 
      row['Stato'] as int, 
      row['Argomento'] ?? ""
    );
    lessonsToday.add(r);
  });

  return lessonsToday;
}

Future<List<Ripetizione>> getNextLessons(int userId) async {
  final db = await openDatabase('ripetizioni.db');
  List<Ripetizione> nextLessons = [];

  final result = await db.rawQuery(
    "SELECT Prenotazioni.*, Corsi.*, Docenti.* "
    "FROM Prenotazioni "
    "INNER JOIN Corsi "
        "ON Prenotazioni.Corso = Corsi.ID "
    "INNER JOIN Docenti "
        "ON Corsi.Docente = Docenti.ID "
    "WHERE Prenotazioni.Giorno IN ('Giovedì', 'Venerdì') "
        "AND Prenotazioni.Studente = ?"
        "AND Prenotazioni.Stato < 2",
    [userId]
  );

  if (result.isEmpty) {
    return nextLessons;
  }

Docente d;
  Materia m;
  Corso c;
  Ripetizione r;

  result.forEach((row) {
    d = Docente.fromData(
      row['Docente'] as int,
      row['Nome'].toString(),
      row['Cognome'].toString(),
      row['Email'].toString(),
      row['valDocente'] == 'TRUE' ? true : false
    );
    m = Materia.fromData(row['Materia'] as String, true);
    c = Corso.fromData(
      row['Corso'] as int, 
      d, 
      m, 
      row['valCorso'] == 'TRUE' ? true : false
    );
    r = Ripetizione.fromData(
      c,
      row['Giorno'].toString(),
      userId,
      row['OraI'] as int,
      row['OraF'] as int,
      row['Stato'] as int,
      row['Argomento'] ?? ""
    );
    nextLessons.add(r);
  });

  return nextLessons;
}

Future<void> deleteLesson(Ripetizione lesson, int userId) async{
  final db = await openDatabase('ripetizioni.db');

  db.rawUpdate(
    "UPDATE Prenotazioni SET Stato = 2 "
        "WHERE Studente = ? AND Giorno = ? AND OraI = ? AND Corso = ?",
    [userId, lesson.giorno, lesson.oraI, lesson.corso.id]
  );
}

Future<void> completeLesson(Ripetizione lesson, int userId) async {
  final db = await openDatabase('ripetizioni.db');

  db.rawUpdate(
      "UPDATE Prenotazioni SET Stato = 1 "
      "WHERE Studente = ? AND Giorno = ? AND OraI = ? AND Corso = ?",
      [userId, lesson.giorno, lesson.oraI, lesson.corso.id]);
}
