import 'package:flutter/widgets.dart';
import 'package:flutter_projet/models/Admin.dart';
import 'package:flutter_projet/models/Composant.dart';
import 'package:flutter_projet/models/Emprunt.dart';
import 'package:flutter_projet/models/Famille.dart';
import 'package:flutter_projet/models/Membre.dart';
import 'package:flutter_projet/models/Retour.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StockDB {
  StockDB._();

  static final StockDB instance = StockDB._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'gestionDBase.db'),
      onCreate: (db, version) {
        _onCreate(db, version);
      },
      version: 1,
    );
  }

  Future _onCreate(Database db, int version) async {
    db.execute(
        "CREATE TABLE admin(id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT, prenom TEXT, tel INTEGER, email TEXT UNIQUE, password TEXT)");
    db.execute(
        "CREATE TABLE Membre(id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT , prenom TEXT, tel INTEGER)");
    db.execute(
        "CREATE TABLE famille(id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT UNIQUE)");
    db.execute(
        "create table composant(id INTEGER  PRIMARY KEY AUTOINCREMENT,nom TEXT UNIQUE,image TEXT,quantite INTEGER,disponible INTEGER,id_famille INTEGER,dateAcquisition TEXT,constraint fk_famille foreign key(id_famille) references Famille(id) )");
    db.execute(
        "create table emprunt(id INTEGER  PRIMARY KEY AUTOINCREMENT,id_composant INTEGER,id_membre INTEGER,quantite INTEGER,dateEmprunt TEXT,emprunte INTEGER,constraint fk_composant foreign key(id_composant) references composant(id),constraint fk_membre foreign key(id_membre) references membre(id) )");
    db.execute(
        "create table retour(id INTEGER  PRIMARY KEY AUTOINCREMENT,etat TEXT,id_emprunt INTEGER,dateRetour TEXT,constraint fk_emprunt foreign key(id_emprunt) references emprunt(id))");
  }

// ********************************************************

  void insertAdmin(Admin admin) async {
    final Database db = await database;
    await db.insert(
      'admin',
      admin.toMap(),
    );
  }

  Future<List> getAuth(String email, String passwrod) async {
    final Database db = await database;
    List<Map<String, dynamic>> list = await db.rawQuery(
        "SELECT * from admin where email='" +
            email +
            "'and password='" +
            passwrod +
            "'");
    List<Admin> users = List.generate(list.length, (i) {
      return Admin.fromMap(list[i]);
    });

    return users;
  }

  void modifierAdmin(email, Admin admin) async {
    final Database db = await database;
    final data = {
      'nom': admin.nom,
      'prenom': admin.prenom,
      'email': admin.email,
      'tel': admin.tel,
      'password': admin.password,
    };
    await db.update('admin', data, where: "email = ?", whereArgs: [email]);

    List<Map<String, dynamic>> list =
        await db.rawQuery("SELECT * from admin where email='" + email + "'");
  }

  // ********************************************************

  void insertFamille(Famille famille) async {
    final Database db = await database;
    await db.insert(
      'famille',
      famille.toMap(),
    );
  }

  Future<List<Map<String, dynamic>>> ListFamille() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('famille');
    return maps;
  }

  Future<int> getFamilleByName(String nom) async {
    final Database db = await database;
    List<Map<String, dynamic>> list =
        await db.rawQuery("SELECT * from famille where nom='" + nom + "'");
    if (!list.isEmpty) {
      return list[0]["id"];
    } else {
      return 0;
    }
  }

  void modifierFamille(
    int id,
    String nom,
  ) async {
    final Database db = await database;
    final data = {
      'nom': nom,
    };
    await db.update('famille', data, where: "id = ?", whereArgs: [id]);
  }

  void supprimerFamille(int id) async {
    final Database db = await database;
    await db.delete('famille', where: "id = ?", whereArgs: [id]);
  }

  Future<List<Famille>> ListFam() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Famille');
    List<Famille> familles = List.generate(maps.length, (i) {
      return Famille.fromMap(maps[i]);
    });
    return familles;
  }

// ********************************************************
// ********************************************************

  void insertComposant(Composant composant) async {
    final Database db = await database;
    await db.insert(
      'composant',
      composant.toMap(),
    );
  }

  Future<List<Map<String, dynamic>>> ListComposant() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('composant');
    return maps;
  }

  void modifierComposant(int id, String nom, String image, int quantite,
      int id_famille, int disponible, String date) async {
    final Database db = await database;
    final data = {
      'nom': nom,
      'image': image,
      'quantite': quantite,
      'disponible': disponible,
      'id_famille': id_famille,
      'dateAcquisition': date
    };
    await db.update('composant', data, where: "id = ?", whereArgs: [id]);
  }

  Future<int> getComposantByName(String nom) async {
    final Database db = await database;
    List<Map<String, dynamic>> list =
        await db.rawQuery("SELECT * from composant where nom='" + nom + "'");
    if (!list.isEmpty) {
      return list[0]["id"];
    } else {
      return 0;
    }
  }

  void supprimerComposant(int id) async {
    final Database db = await database;
    await db.delete('composant', where: "id = ?", whereArgs: [id]);
  }

  Future<List<Composant>> ListComp() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('composant');

    List<Composant> composants = List.generate(maps.length, (i) {
      return Composant.fromMap(maps[i]);
    });
    return composants;
  }

// ********************************************************
// ********************************************************

  void insertMembre(Membre membre) async {
    final Database db = await database;
    await db.insert(
      'membre',
      membre.toMap(),
    );
  }

  Future<List<Map<String, dynamic>>> ListMembre() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('membre');
    return maps;
  }

  Future<int> getMembreByName(String nom) async {
    final Database db = await database;
    List<Map<String, dynamic>> list =
        await db.rawQuery("SELECT * from membre where nom='" + nom + "'");
    if (!list.isEmpty) {
      return list[0]["id"];
    } else {
      return 0;
    }
  }

  void modifierMembre(
    int id,
    String nom,
    String prenom,
    int tel,
  ) async {
    final Database db = await database;
    final data = {'nom': nom, 'prenom': prenom, 'tel': tel};
    await db.update('membre', data, where: "id = ?", whereArgs: [id]);
  }

  void supprimerMembre(int id) async {
    final Database db = await database;
    await db.delete('membre', where: "id = ?", whereArgs: [id]);
  }

  Future<List<Membre>> ListMem() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('membre');

    List<Membre> membres = List.generate(maps.length, (i) {
      return Membre.fromMap(maps[i]);
    });
    return membres;
  }

// ********************************************************
// ********************************************************

  Future<int> insertEmprunt(Emprunt emprunt) async {
    final Database db = await database;

    List<Map<String, dynamic>> list = await db
        .rawQuery("SELECT * from composant where id=${emprunt.id_composant}");

    if (!list.isEmpty) {
      int qt = list[0]["quantite"] - emprunt.quantite;
      int dispo = 1;
      if (qt <= 0) {
        dispo = 0;
      }
      if (qt < 0) return 0;

      final data = {"quantite": qt, "disponible": dispo};

      await db.update('composant', data,
          where: "id = ?", whereArgs: [emprunt.id_composant]);

      await db.insert(
        'emprunt',
        emprunt.toMap(),
      );
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> getEmpruntByDate(String date) async {
    final Database db = await database;
    List<Map<String, dynamic>> list = await db
        .rawQuery("SELECT * from emprunt where dateEmprunt='" + date + "'");
    if (!list.isEmpty) {
      return list[0]["id"];
    } else {
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> ListEmprunt() async {
    final Database db = await database;
    List<Map<String, dynamic>> list = await db.rawQuery(
        "SELECT e.*,c.nom,m.tel,m.prenom from composant c ,emprunt e,membre m  where e.id_composant=c.id and m.id=e.id_membre");
    return list;
  }

  void supprimerEmprunt(int id) async {
    final Database db = await database;
    await db.delete('emprunt', where: "id = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> ListEmp() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * from emprunt where emprunte=0 ");
    return maps;
  }

// ********************************************************
// ********************************************************

  Future<int> inserRetour(Retour retour) async {
    final Database db = await database;
    final data = {
      'emprunte ': 1,
    };
    await db.update('emprunt', data,
        where: "id = ?", whereArgs: [retour.id_emprunt]);

    List<Map<String, dynamic>> emprunt = await db
        .rawQuery("SELECT * from emprunt where id=${retour.id_emprunt}");

    if (!emprunt.isEmpty) {
      int id_composant = emprunt[0]["id_composant"];
      List<Map<String, dynamic>> composant =
          await db.rawQuery("SELECT * from composant where id=$id_composant");

      if (!composant.isEmpty) {
        int qt = composant[0]["quantite"] + emprunt[0]["quantite"];
        final data = {"quantite": qt, "disponible": 1};
        await db.update('composant', data,
            where: "id = ?", whereArgs: [id_composant]);
        await db.insert(
          'retour',
          retour.toMap(),
        );
        return 1;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> ListRetour() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('retour');
    return maps;
  }

  void SupprimerRetour(int id) async {
    final Database db = await database;
    await db.delete('retour', where: "id = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> ListComposantNoRetourne() async {
    final Database db = await database;
    // final List<Map<String, dynamic>> maps = await db.rawQuery(
    //     "SELECT * from composant where id in (select id_composant from emprunt where emprunte=0)");

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "select c.nom,m.tel,m.prenom from composant c,emprunt e,membre m where c.id=e.id_composant and m.id=e.id_membre and e.emprunte=0");
    return maps;
  }

  Future<List<Map<String, dynamic>>> search(String nom) async {
    final Database db = await database;
    List<Map<String, dynamic>> list =
        await db.rawQuery("SELECT * from composant where nom='" + nom + "'");
    return list;
  }
}
