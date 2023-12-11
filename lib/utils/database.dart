import 'dart:async';
import 'package:password_manager/utils/database_columns.dart';
import 'package:password_manager/utils/database_tables.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const int DB_VERSION = 2;

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
        onCreate: _createCallback,
        onUpgrade: _updateCallback,
    );
  }

  void _createCallback(Database db, int version) async {
    await db.execute(_getPasswordSchema());
    await db.execute(_getSuperPasswordSchema());
    await db.execute(_getPasswordRequestSchema());
  }

  void _updateCallback(Database db, int oldVersion, int newVersion) {
    if(oldVersion == 1) {
      var now = DateTime.now().toUtc();
      String isoDate = now.toIso8601String();
      db.execute("ALTER TABLE ${DatabaseTables.PASSWORD} ADD COLUMN ${DatabaseColumn.CreatedAt} TEXT DEFAULT '$isoDate';");
      db.execute("ALTER TABLE ${DatabaseTables.PASSWORD} ADD COLUMN ${DatabaseColumn.UpdatedAt} TEXT DEFAULT '$isoDate';");
    }

  }


  String _getPasswordSchema() {
    return "CREATE TABLE ${DatabaseTables.PASSWORD} ("
      "id INTEGER PRIMARY KEY,"
      "account_name TEXT NOT NULL,"
      "email TEXT,"
      "username TEXT,"
      "password TEXT NOT NULL,"
      "is_secret INTEGER default 0"
      ");";
  }

  String _getSuperPasswordSchema() {
    return "CREATE TABLE ${DatabaseTables.SUPER_PASSWORD} ("
        "id INTEGER PRIMARY KEY,"
        "password TEXT NOT NULL"
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