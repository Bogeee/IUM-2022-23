class User {
  int _id = 0;
  String _nome = ''; 
  String _cognome = ''; 
  String _email = ''; 
  String _pwd = ''; 
  bool _isAdmin = false;

  User();

  User.fromData(id, nome, cognome, email, pwd, isAdmin){
    _id = id;
    _nome = nome;
    _cognome = cognome;
    _email = email;
    _pwd = pwd;
    _isAdmin = isAdmin;
  }

  int get id => _id;

  String get nome => _nome; 
  String get cognome => _cognome; 
  String get email => _email; 
  String get password => _pwd;

  bool get isAdmin => _isAdmin; 
}