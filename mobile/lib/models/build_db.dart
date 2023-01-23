import 'package:sqflite/sqflite.dart';

Future<void> createDB() async {
  Database db = await openDatabase('ripetizioni.db', version: 1,
      onCreate: (db, version) async {
        // Docenti
        await db.execute("CREATE TABLE Docenti("
            "ID INTEGER PRIMARY KEY, "
            "Nome VARCHAR(32) NOT NULL, "
            "Cognome VARCHAR(32) NOT NULL, "
            "Email VARCHAR(64) UNIQUE NOT NULL, "
            "valDocente BOOLEAN DEFAULT TRUE NOT NULL"
            ");");

        // Materie
        await db.execute("CREATE TABLE Materie("
            "Nome VARCHAR(50) PRIMARY KEY, "
            "valMateria BOOLEAN DEFAULT TRUE NOT NULL"
            ");");

        // Corsi
        await db.execute("CREATE TABLE Corsi("
            "ID INTEGER PRIMARY KEY, "
            "Docente INTEGER NOT NULL, "
            "Materia VARCHAR(50) NOT NULL, "
            "valCorso BOOLEAN DEFAULT TRUE NOT NULL, "
            "UNIQUE(Docente, Materia), "
            "FOREIGN KEY(Docente) REFERENCES Docenti(ID), "
            "FOREIGN KEY(Materia) REFERENCES Materie(Nome)"
            ");");

        // Users
        await db.execute("CREATE TABLE Users("
            "ID INTEGER PRIMARY KEY, "
            "Nome VARCHAR(32) NOT NULL, "
            "Cognome VARCHAR(32) NOT NULL, "
            "Email VARCHAR(64) UNIQUE NOT NULL, "
            "Pwd VARCHAR(64) NOT NULL, "
            "isAdmin BOOLEAN DEFAULT FALSE NOT NULL"
            ");");

    // Prenotazioni
    await db.execute("CREATE TABLE Prenotazioni("
        "Corso INTEGER NOT NULL, "
        "Giorno VARCHAR(10) NOT NULL, "
        "Studente INTEGER NOT NULL, "
        "OraI INTEGER NOT NULL CHECK("
        "(OraI >= 9 AND OraI <= 12) OR "
        "(OraI >= 15 AND OraI <= 18)), "
        "OraF INTEGER NOT NULL CHECK("
        "(OraF >= 10 AND OraF <= 13) OR "
        "(OraF >= 16 AND OraF <= 19)), "
        "Stato INTEGER DEFAULT 0 NOT NULL "
        "CHECK(Stato >= 0 AND Stato <= 2), "
        "Argomento VARCHAR(512), "
        "PRIMARY KEY(Corso, Giorno, Studente, OraI), "
        "FOREIGN KEY(Corso) REFERENCES Corsi(ID), "
        "FOREIGN KEY(Studente) REFERENCES Users(ID)"
        ");");

    // tmp table to fetch available lessons
    await db.execute("CREATE TABLE Ripetizioni("
        "Corso INT NOT NULL,"
        "Giorno VARCHAR NOT NULL,"
        "OraI INT NOT NULL,"
        "OraF INT NOT NULL,"
        "PRIMARY KEY (Corso, Giorno, OraI, OraF)"
        ");");

    // Insert Docenti
    await db.execute("INSERT INTO Docenti(Nome, Cognome, Email) VALUES "
        "('Mario', 'Rossi', 'mario.rossi@gmail.com'), " 
        "('Maria', 'Bianchi', 'maria.bianchi@gmail.com'), " 
        "('Luca', 'Verdi', 'luca.verdi@gmail.com'), " 
        "('Lucia', 'Gialli', 'lucia.gialli@gmail.com'), " 
        "('Maurizio', 'Rosa', 'maurizio.rosa@gmail.com'), " 
        "('Sara', 'Neri', 'sara.neri@gmail.com'), " 
        "('Alessio', 'Bravi', 'alessio.bravi@gmail.com'), " 
        "('Alessia', 'Belli', 'alessia.belli@gmail.com'), " 
        "('Gianpaolo', 'Maggiore', 'giampy.magg@gmail.com'), " 
        "('Maria Grazia', 'Berardo', 'mg.berardo@gmail.com'), "
        "('Tancredi', 'Canonico', 'dino@gmail.com'), " 
        "('Sofia', 'Turchese', 'sofia.turchese@gmail.com'), "
        "('Roberto', 'Mana', 'supermana@gmail.com'), "
        "('Marino', 'Segnan', 'marino.segnan@gmail.com'), "
        "('Idilio', 'Drago', 'dr4g0@gmail.com'), "
        "('Viviana', 'Bono', 'bobovivi@gmail.com'), " 
        "('Cristina', 'Gena', 'cristina.gena@gmail.com');"
    );

        // Insert Docenti
        await db.execute("INSERT INTO Docenti(Nome, Cognome, Email) VALUES "
            "('Mario', 'Rossi', 'mario.rossi@gmail.com'), "
            "('Maria', 'Bianchi', 'maria.bianchi@gmail.com'), "
            "('Luca', 'Verdi', 'luca.verdi@gmail.com'), "
            "('Lucia', 'Gialli', 'lucia.gialli@gmail.com'), "
            "('Maurizio', 'Rosa', 'maurizio.rosa@gmail.com'), "
            "('Sara', 'Neri', 'sara.neri@gmail.com'), "
            "('Alessio', 'Bravi', 'alessio.bravi@gmail.com'), "
            "('Alessia', 'Belli', 'alessia.belli@gmail.com'), "
            "('Gianpaolo', 'Maggiore', 'giampy.magg@gmail.com'), "
            "('Maria Grazia', 'Berardo', 'mg.berardo@gmail.com'), "
            "('Tancredi', 'Canonico', 'dino@gmail.com'), "
            "('Sofia', 'Turchese', 'sofia.turchese@gmail.com'), "
            "('Roberto', 'Mana', 'supermana@gmail.com'), "
            "('Marino', 'Segnan', 'marino.segnan@gmail.com'), "
            "('Idilio', 'Drago', 'dr4g0@gmail.com'), "
            "('Viviana', 'Bono', 'bobovivi@gmail.com'), "
            "('Cristina', 'Gena', 'cristina.gena@gmail.com');"
        );

        // Insert Materie
        await db.execute("INSERT INTO Materie(Nome) VALUES "
            "('Algoritmi'), "
            "('Database'), "
            "('Cybersecurity'), "
            "('Reti'), "
            "('Informatica'), "
            "('Elettrotecnica'), "
            "('Meccanica'), "
            "('Fisica'), "
            "('Algebra'), "
            "('Analisi'), "
            "('Geometria'), "
            "('Matematica'), "
            "('Chimica'), "
            "('Musica'), "
            "('Medicina'), "
            "('Finanza'), "
            "('Economia'), "
            "('Marketing'), "
            "('Latino'), "
            "('Inglese'), "
            "('Letteratura'), "
            "('Storia'), "
            "('Geografia'), "
            "('Francese'), "
            "('Portoghese'), "
            "('Diritto'), "
            "('Disegno tecnico');"
        );

    // Insert Users
    // Bcrypt password hashes, cost_factor = 10, salt = '\$2y'
    // ----------------------------------------
    // admin@ripetizioni.it:administrator
    // filippo.bogetti@edu.unito.it:password
    // stefano.fontana266@edu.unito.it:password
    // ----------------------------------------
    // useless@polito.it:UserInterface    -> questo account lo usiamo come demo dell'interfaccia di un utente
    //                                       che non ha mai usato l'app. 
    await db.execute(
      "INSERT INTO Users(Nome, Cognome, Email, Pwd, isAdmin) VALUES "
          "('admin', 'root', 'admin@ripetizioni.it', '\$2y\$10\$GIrhZA6NHU9BmqS2CU9Q4eqA2xQIhCEgd30IzjkYq0QAoZBkFp6vi', 1), "
          "('Filippo', 'Bogetti', 'filippo.bogetti@edu.unito.it', '\$2y\$10\$YGXS0..6HcJOUjSZSBZbWuDyTe4G9K5eyQgAhk3YO5YzJpyR0nES6', 0), "
          "('Stefano', 'Fontana', 'stefano.fontana266@edu.unito.it', '\$2y\$10\$YGXS0..6HcJOUjSZSBZbWuDyTe4G9K5eyQgAhk3YO5YzJpyR0nES6', 0), "
          "('Account', 'Non Usato', 'useless@polito.it', '\$2y\$10\$6IK1zP69iXD0eWqulA7JMOQgw9iopFDzgD6NbGZXmIwDAiMcwE4CK', 0);"
    );

    await db.execute(
      "INSERT INTO Prenotazioni(Corso, Giorno, Studente, OraI, OraF, Stato, Argomento) VALUES "
          "(1, 'Mercoledì', 2, 9, 10, 0, NULL),"
          "(1, 'Mercoledì', 2, 10, 11, 0, 'Algoritmo di Dijkstra'),"
          "(1, 'Giovedì', 2, 10, 11, 0, NULL),"
          "(1, 'Mercoledì', 2, 11, 12, 0, NULL);"
    );
  });
}
