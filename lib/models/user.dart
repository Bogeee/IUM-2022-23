import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

const String fileName = 'saved_user.json';
const String firstOpeningFileName = 'first_opening.text';

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

  Map<String, dynamic> toMap(){
    return {
      'id': _id,
      'nome': _nome,
      'cognome': _cognome,
      'email': _email,
      'pwd': _pwd,
      'isAdmin': _isAdmin
    };
  }

  static User? fromMap(Map<String, dynamic> map) {
    if(map == null){
      return null;
    }

    return User.fromData(
      map['id'] as int, 
      map['nome'] as String, 
      map['cognome'] as String, 
      map['email'] as String, 
      map['pwd'] as String, 
      map['isAdmin'] == 1 ? true : false
    );
  }

  String toJson() => json.encode(toMap());

  static User? fromJson(String jsonEncoded) => fromMap(json.decode(jsonEncoded));

  static Future<User?> readUserFromLocalStorage() async {
    try{
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/$fileName');

      if(await file.exists() == false){
        return null;
      }

      String savedUser = await file.readAsString();
      return savedUser.isEmpty ? null : User.fromJson(savedUser); 
    } catch (e){
      // IOException
      return null;
    }
  }

  static Future<File> writeUserToLocalStorage(User savedUser) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$fileName');

    return file.writeAsString(savedUser.toJson());
  }

  Future<void> removeUserFromLocalStorage() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$fileName');

    bool exists = await file.exists();
    exists ? file.delete() : null;
  }

  static Future<bool> isFirstOpening() async {
  final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$firstOpeningFileName');

    if (await file.exists() == false) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> onboardingComplete() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$firstOpeningFileName');

    if (await file.exists() == false) {
      file.writeAsString('true');
    }
  }
}