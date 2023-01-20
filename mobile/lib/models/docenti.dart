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
