import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

// models
import 'package:proj/models/user.dart';

class RegisterInfo {
  final bool _success;
  final String _message;

  RegisterInfo(this._success, this._message);

  bool get success => _success;
  String get message => _message;
}

Future<RegisterInfo> registerUser( String nome, String cognome, String email, String password) async {
  final db = await openDatabase('ripetizioni.db');

  try {
    final result =
      await db.insert('Users', {
        'Nome': nome,
        'Cognome': cognome,
        'Email': email,
        'Pwd': BCrypt.hashpw(password, BCrypt.gensalt(prefix: '\$2y')),
        'isAdmin': 0
      });

    return RegisterInfo(result != 1, "");
  } on DatabaseException catch(databaseException) {
    if(databaseException.isUniqueConstraintError()) {
      return RegisterInfo(false, "L'email inserita è già utilizzata per un altro account. Inserirne un'altra.");
    } else {
      return RegisterInfo(false, "Errore durante la registrazione. Riprovare.");
    }
  }
}
