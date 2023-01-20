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
