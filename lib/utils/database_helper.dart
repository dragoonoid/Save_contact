import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqlite_intro/models/contact.dart';

class DatabaseHelper {
  static const dbName = 'ContactData.db';
  static const dbVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database = null;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  Future<Database?> _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.toString(), dbName);
    return await openDatabase(dbPath,
        version: dbVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database? db, int version) async {
    await db?.execute('''
    CREATE TABLE 'Contact'(
      'id' INTEGER PRIMARY KEY AUTOINCREMENT,
      'name' TEXT NOT NULL,
      'number' TEXT NOT NULL
    )
    ''');
  }

  Future<int?> insertContact(Contact contact) async {
    Database? db = await database;
    if (db != null) {
      return await db.insert('Contact', contact.toMap());
    }
  }

  Future<int?> updateContact(Contact contact) async {
    Database? db = await database;
    if (db != null) {
      return await db.update('Contact', contact.toMap(),
          where: 'id=?', whereArgs: [contact.id]);
    }
  }
  Future<int?> deleteContact(int? id) async {
    Database? db = await database;
    if (db != null) {
      return await db.delete('Contact',
          where: 'id=?', whereArgs: [id]);
    }
  }

  Future<List<Contact>> fetchContacts() async {
    Database? db = await database;
    if (db != null) {
      List<Map> contacts = await db.query('Contact');
      return contacts.length == 0
          ? []
          : contacts.map((e) => Contact.fromMap(e)).toList();
    }
    return [];
  }
}
