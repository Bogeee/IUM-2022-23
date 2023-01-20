import 'package:proj/models/docenti.dart';
import 'package:proj/models/materie.dart';

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
