import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  DBHelper._();

  static DBHelper? _instance;
  static Database? myDatabase;

  static DBHelper getInstance() {
    // ignore: prefer_conditional_assignment
    if (_instance == null) {
      _instance = DBHelper._();
    }
    return _instance!;
  }

  Future<Database> getDB() async {
    // ignore: prefer_conditional_assignment
    if (myDatabase == null) {
      myDatabase = await openDB();
    }
    return myDatabase!;
  }

  Future<Database> openDB() async {
    Directory applicationDirectoryDetails =
        await getApplicationDocumentsDirectory();
    String dbPath = join(applicationDirectoryDetails.path, "KHATA_DATABASE.db");
    openDatabase(
      dbPath,
      onCreate: (db, version) {
      /// htis is calback
      },
      version: 1,
    );
    return myDatabase!;
  }
}
