import 'dart:async';
import 'package:password_manager/utils/database_tables.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const int DB_VERSION = 1;

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database?> get database async {
    if(_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'radford_password_manager.db');
    return await openDatabase(path,
        version: DB_VERSION,
        onOpen: (db) {},
        onCreate: _createCallback
    );
  }

  void _createCallback(Database db, int version) async {
    await db.execute(_getUserSchema());
    await db.execute(_getPasswordRequestSchema());
  }


  String _getUserSchema() {
    return "CREATE TABLE ${DatabaseTables.PASSWORD} ("
      "id INTEGER PRIMARY KEY,"
      "account_name TEXT,"
      "email TEXT,"
      "username TEXT,"
      "password TEXT,"
      "is_secret INTEGER default 0,"
      "is_super INTEGER default 0"
      ");";
  }

  String _getPasswordRequestSchema() {
    return "CREATE TABLE ${DatabaseTables.PASSWORD_REQUEST_SETTINGS} ("
        "id INTEGER PRIMARY KEY,"
        "request_name TEXT,"
        "should_request INTEGER default 1"
        ");";
  }

}