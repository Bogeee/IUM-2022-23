import 'package:proj/models/user.dart';
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

Future<List<Ripetizione>> getOldLessons(int userId) async {
  final db = await openDatabase('ripetizioni.db');
  List<Ripetizione> oldLessons = [];

  final result = await db.rawQuery(
      "SELECT Prenotazioni.*, Corsi.*, Docenti.* "
      "FROM Prenotazioni "
      "INNER JOIN Corsi "
      "ON Prenotazioni.Corso = Corsi.ID "
      "INNER JOIN Docenti "
      "ON Corsi.Docente = Docenti.ID "
      "WHERE Prenotazioni.Giorno IN ('Lunedì', 'Martedì') "
      "AND Prenotazioni.Studente = ?",
      [userId]);

  if (result.isEmpty) {
    return oldLessons;
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
        row['valDocente'] == 'TRUE' ? true : false);
    m = Materia.fromData(row['Materia'] as String, true);
    c = Corso.fromData(
        row['Corso'] as int, d, m, row['valCorso'] == 'TRUE' ? true : false);
    r = Ripetizione.fromData(
        c,
        row['Giorno'].toString(),
        userId,
        row['OraI'] as int,
        row['OraF'] as int,
        row['Stato'] as int,
        row['Argomento'] ?? "");
    oldLessons.add(r);
  });

  return oldLessons;
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

Future<List<Ripetizione>> searchFreeLessons(int userId, String subject,
    Docente? professor, String day,
    int timeStart, int timeEnd, bool limit) async {
  final db = await openDatabase('ripetizioni.db');
  List<Ripetizione> freeLessons = [];

  await db.execute("DELETE FROM Ripetizioni;");

  final courses = await db.query("Corsi",
    columns: ["ID"],
    where: "Materia = ? AND valCorso = 'TRUE'",
    whereArgs: [subject]
  );

  for (var course in courses) {
    int jLimit = 13;
    for (int i = 9; i <= 18; i++) {
      for (int j = i + 1; j <= jLimit; j++) {
        try {
          await db.rawInsert("INSERT INTO Ripetizioni VALUES (?, ?, ?, ?);",
              [course["ID"] as int, day, i, j]);
        } catch (e) {
          // NOP
        }
      }

      if (i == 12) {
        i = 14;
        jLimit = 19;
      }
    }
  }

  // FIXME: SQL Injection, fix with 2 queries if we have time
  final result = await db.rawQuery(
      "SELECT Ris.*, C.ID AS Corso, C.*, D.* "
      "FROM ( "
      "SELECT * "
      "FROM Ripetizioni AS R "
      "WHERE NOT EXISTS ( "
      "SELECT C1.ID, P.Giorno, P.OraI, P.OraF "
      "FROM Prenotazioni AS P INNER JOIN Corsi AS C1 ON C1.ID = P.Corso "
      "WHERE C1.ID = R.Corso AND P.Giorno = R.Giorno AND P.OraI < R.OraF AND P.OraF > R.OraI AND P.Stato != 2) "
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
      [timeStart, timeEnd]);

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
        row['valDocente'] == 'TRUE' ? true : false);
    m = Materia.fromData(row['Materia'] as String, true);
    c = Corso.fromData(
        row['Corso'] as int, d, m, row['valCorso'] == 'TRUE' ? true : false);
    r = Ripetizione.fromData(c, row['Giorno'].toString(), userId,
        row['OraI'] as int, row['OraF'] as int, 4, "");
    freeLessons.add(r);
  });

  return freeLessons;
}

Future<List<Ripetizione>> getSuggestedLessons(
    List<Materia> previousSubjects, int userId, String day) async {
  List<Ripetizione> suggestedLessons = [];

  for (Materia subject in previousSubjects) {
    suggestedLessons.addAll( await searchFreeLessons(userId, subject.nome, null, day, 9, 10, true));
    suggestedLessons.addAll( await searchFreeLessons(userId, subject.nome, null, day, 12, 13, true));
    suggestedLessons.addAll( await searchFreeLessons(userId, subject.nome, null, day, 15, 16, true));
    suggestedLessons.addAll( await searchFreeLessons(userId, subject.nome, null, day, 18, 19, true));
  }

  return suggestedLessons;
}

Future<String> insertLesson(Ripetizione lesson, String argument) async {
  final db = await openDatabase('ripetizioni.db');

  final result = await db.query("Prenotazioni",
    where: "Stato <> 2 AND Giorno = ? AND OraI < ? AND OraF > ? AND Studente = ?",
    whereArgs: [lesson.giorno, lesson.oraF, lesson.oraI, lesson.studente]);

  try{
    if (result.isEmpty) {
      await db.execute(
          "INSERT INTO Prenotazioni(Corso, Giorno, Studente, OraI, OraF, Argomento) VALUES (?, ?, ?, ?, ?, ?)",
          [
            lesson.corso.id,
            lesson.giorno,
            lesson.studente,
            lesson.oraI,
            lesson.oraF,
            argument
          ]);
      return "OK";
    } else {
      return "KO";
    }
  }catch(e){
    return "ALR";
  }
}

Future<List<Ripetizione>> getActiveLessons(String studEmail, String subject, Docente? prof,
    String day, int init, int end) async{
  final db = await openDatabase('ripetizioni.db');

  List<Ripetizione> activeLessons = [];
  int studentID = 0;
  int courseID = 0;

  bool student = studEmail != "";
  if(student) {
    studentID = await getUserIDFromEmail(studEmail);
  }

  bool professor = prof != null && prof.id != -1;
  if(professor) {
    courseID = await getCourseIDFromProfessorSubject(prof, subject);
  }

  final result;

  if(student && professor){
    result = await db.rawQuery(
      'SELECT P.*, C.*, D.* FROM Prenotazioni AS P '
        'INNER JOIN Corsi AS C ON P.Corso = C.ID '
        'INNER JOIN Docenti AS D ON C.Docente = D.ID '
        'WHERE P.Studente = ? AND P.Stato = 0 AND P.Corso = ? '
            'AND P.Giorno = ? AND P.OraI >= ? AND P.OraI < ? '
            'AND P.OraF <= ?',
        [studentID, courseID, day, init, end, end]
    );
  } else if (student && !professor){
      result = await db.rawQuery(
        'SELECT P.*, C.*, D.* FROM Prenotazioni AS P '
          'INNER JOIN Corsi AS C ON P.Corso = C.ID '
          'INNER JOIN Docenti AS D ON C.Docente = D.ID '
          'WHERE P.Studente = ? AND P.Stato = 0 AND C.Materia = ? '
              'AND P.Giorno = ? AND P.OraI >= ? AND P.OraI < ? '
              'AND P.OraF <= ?',
          [studentID, subject, day, init, end, end]
      );
  } else {
    result = await db.rawQuery(
      'SELECT P.*, C.*, D.* FROM Prenotazioni AS P '
        'INNER JOIN Corsi AS C ON P.Corso = C.ID '
        'INNER JOIN Docenti AS D ON C.Docente = D.ID '
        'WHERE P.Stato = 0 AND P.Corso = ? AND P.Giorno = ? '
            'AND P.OraI >= ? AND P.OraI < ? AND P.OraF <= ?',
        [courseID, day, init, end, end]
    );
  }

  if (result.isEmpty) {
    return activeLessons;
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
        row['valDocente'] == 'TRUE' ? true : false);
    m = Materia.fromData(row['Materia'] as String, true);
    c = Corso.fromData(
        row['Corso'] as int, d, m, row['valCorso'] == 'TRUE' ? true : false);
    r = Ripetizione.fromData(c, row['Giorno'].toString(), row['Studente'] as int,
        row['OraI'] as int, row['OraF'] as int, 0, row['Argomento'] ?? "");
    activeLessons.add(r);
  });

  return activeLessons;
}