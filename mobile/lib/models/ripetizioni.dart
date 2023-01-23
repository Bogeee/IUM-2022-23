import 'package:proj/models/docenti.dart';
import 'package:proj/models/materie.dart';
import 'package:sqflite/sqflite.dart';
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

Future<List<Ripetizione>> searchFreeLessons(int userId, String subject, Docente? professor, String day, int timeStart, int timeEnd, bool limit) async {
  final db = await openDatabase('ripetizioni.db');
  List<Ripetizione> freeLessons = [];

  await db.execute("DELETE FROM Ripetizioni;");

  final courses = await db.query("Corsi", columns: ["ID"], where: "Materia = ? AND valCorso = 'TRUE'", whereArgs: [subject]);

  for(var course in courses) {
    int jLimit = 13;
    for (int i = 9; i <= 18; i++) {
      for(int j = i+1; j <= jLimit; j++) {
        try{
          await db.rawInsert("INSERT INTO Ripetizioni VALUES (?, ?, ?, ?);", [course["ID"] as int, day, i, j]);
        } catch(e){
          // NOP
        }
      }

      if (i == 12) {
        i = 14;
        jLimit = 19;
      }
    }
  }

  // FIXME: SQL Injection
  final result = await db.rawQuery(
      "SELECT Ris.*, C.ID AS Corso, C.*, D.* "
          "FROM ( "
          "SELECT * "
          "FROM Ripetizioni AS R "
          "WHERE NOT EXISTS ( "
          "SELECT C1.ID, P.Giorno, P.OraI, P.OraF "
          "FROM Prenotazioni AS P INNER JOIN Corsi AS C1 ON C1.ID = P.Corso "
          "WHERE C1.ID = R.Corso AND P.Giorno = R.Giorno AND P.OraI < R.OraF AND P.OraF > R.OraI) "
          ") AS Ris INNER JOIN Corsi AS C "
          "ON C.ID = Ris.Corso "
          "INNER JOIN Docenti AS D "
          "ON D.ID = C.Docente "
          "INNER JOIN Materie AS M "
          "ON C.Materia = M.Nome "
          "WHERE Ris.OraI >= ? AND Ris.OraF <= ? AND D.valDocente = 'TRUE' AND C.valCorso = 'TRUE' AND M.valMateria = 'TRUE' "
          "${professor != null && professor.id != -1 ? "AND D.ID = ${professor.id} " : ""}"
          "ORDER BY OraI, OraF, D.Cognome, D.Nome "
          "${limit ? "LIMIT 10" : ""};", // FIXME: il limit non funziona!!!
      [timeStart, timeEnd]
  );

  if (result.isEmpty) {
    return freeLessons;
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
        4,
        ""
    );
    freeLessons.add(r);
  });

  return freeLessons;
}

Future<List<Ripetizione>> getSuggestedLessons(List<Materia> previousSubjects, int userId, String day) async {
  List<Ripetizione> suggestedLessons = [];

  for(Materia subject in previousSubjects) {
      suggestedLessons.addAll(await searchFreeLessons(userId, subject.nome, null, day, 9, 10, true));
      suggestedLessons.addAll(await searchFreeLessons(userId, subject.nome, null, day, 12, 13, true));
      suggestedLessons.addAll(await searchFreeLessons(userId, subject.nome, null, day, 15, 16, true));
      suggestedLessons.addAll(await searchFreeLessons(userId, subject.nome, null, day, 18, 19, true));
  }

  return suggestedLessons;
}

Future<String> insertLesson(Ripetizione lesson, String argument) async {
  final db = await openDatabase('ripetizioni.db');

  final result = await db.query("Prenotazioni",
      where: "Stato <> 2 AND Giorno = ? AND OraI < ? AND OraF > ? AND Studente = ?",
      whereArgs: [lesson.giorno, lesson.oraF, lesson.oraI, lesson.studente]
  );

  if(result.isEmpty) {
      await db.execute("INSERT INTO Prenotazioni(Corso, Giorno, Studente, OraI, OraF, Argomento) VALUES (?, ?, ?, ?, ?, ?)",
        [lesson.corso.id, lesson.giorno, lesson.studente, lesson.oraI, lesson.oraF, argument]
      );
      return "OK";
  } else {
      return "KO";
  }
}