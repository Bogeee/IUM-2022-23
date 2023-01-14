import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

// models
import 'package:proj/models/user.dart';

class LoginInfo {
  final bool _success;
  final User _user;

  LoginInfo(this._success, this._user);

  bool get success => _success;

  User get user => _user;
}

Future<LoginInfo> testLogin( String email, String password, bool? remindme) async {
  final db = await openDatabase('ripetizioni.db');
  User loggedIn = User();

  final result =
      await db.query('Users', where: 'Email = ?', whereArgs: [email]);

  if (result.isEmpty) {
    return LoginInfo(false, loggedIn);
  }

  String bcryptHash = result[0]['Pwd'] as String;

  bool success = BCrypt.checkpw(password, bcryptHash);

  if (success) {
    int id = result[0]['ID'] as int;
    String nome = result[0]['Nome'] as String;
    String cognome = result[0]['Cognome'] as String;
    String email = result[0]['Email'] as String;
    String pwd = result[0]['Pwd'] as String;
    bool isAdmin = result[0]['isAdmin'] == 1 ? true : false;

    loggedIn = User.fromData(id, nome, cognome, email, pwd, isAdmin);
  }

  return LoginInfo(success, loggedIn);
}

Future<LoginInfo> testLoginCrypted( String email, String password, bool? remindme) async {
  final db = await openDatabase('ripetizioni.db');
  User loggedIn = User();

  final result =
      await db.query('Users', where: 'Email = ?', whereArgs: [email]);

  if (result.isEmpty) {
    return LoginInfo(false, loggedIn);
  }

  String bcryptHash = result[0]['Pwd'] as String;

  bool success = password == bcryptHash;

  if (success) {
    int id = result[0]['ID'] as int;
    String nome = result[0]['Nome'] as String;
    String cognome = result[0]['Cognome'] as String;
    String email = result[0]['Email'] as String;
    String pwd = result[0]['Pwd'] as String;
    bool isAdmin = result[0]['isAdmin'] == 1 ? true : false;

    loggedIn = User.fromData(id, nome, cognome, email, pwd, isAdmin);
  }

  return LoginInfo(success, loggedIn);
}
