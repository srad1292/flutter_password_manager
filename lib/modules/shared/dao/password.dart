

import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/utils/database.dart';
import 'package:sqflite/sqflite.dart';

class PasswordDao {

  PasswordDao();

  Future<int> addOrReplacePassword(Password password) async {
    Database? db = await DBProvider.db.database;
    try {
      int? id = await db?.insert("password", password.toPersistence(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return id ?? -1;
    } catch(error) {
      print("Error adding or replacing password");
      print(error);
    }
    return -1;
  }

  /// Returns super password if found, empty password if not, null if error
  Future<Password?> getSuperPassword() async {
    Database? db = await DBProvider.db.database;
    try {
      List<Map<String, dynamic>>? dbPasswords = await db?.query(
        "password",
        where: "is_super = ?",
        whereArgs:[1]
      );

      if(dbPasswords != null && dbPasswords.length > 0) {
        return List.generate(dbPasswords.length, (index) {
          return Password.fromPersistence(dbPasswords[index]);
        })[0];
      } else {
        return new Password();
      }
    } catch(error) {
      print("Error in getSuperPassword");
      print(error);
    }

    return null;
  }

  Future<Password?> getPasswordById({int passwordId = 0}) async {
    if(passwordId <= 0) { return null; }

    Database? db = await DBProvider.db.database;
    try {
      List<Map<String, dynamic>>? dbPassword = await db?.query("password", where: "id = ?", whereArgs: [passwordId], limit: 1);
      if(dbPassword != null && dbPassword.length > 0) {
        return Password.fromPersistence(dbPassword[0]);
      } else {
        return null;
      }
    } on Exception catch (e) {
      print("Error getting password by ID: $passwordId");
      print(e);
    }
    return null;
  }

  Future<List<Password>> getAllPasswords({bool showSecret = false, String accountSearch = ''}) async {
    Database? db = await DBProvider.db.database;
    try {
      List<Map<String, dynamic>>? dbPasswords = await db?.query(
        "password",
        where: showSecret ? "is_super = ? and account_name like ?" : "is_super = ? and is_secret = ? and account_name like ?",
        whereArgs: showSecret ? [0, "%${accountSearch.toLowerCase()}%"] : [0, 0, "%${accountSearch.toLowerCase()}%"]
      );
      if(dbPasswords != null && dbPasswords.length > 0) {
        return List.generate(dbPasswords.length, (index) {
          return Password.fromPersistence(dbPasswords[index]);
        });
      } else {
        return [];
      }
    } catch(error) {
      print("Error in getAllPasswords");
      print(error);
    }

    return [];
  }

  Future<int> deletePassword({int passwordId = -1}) async {
    if(passwordId <= 0) { return 0; }

    Database? db = await DBProvider.db.database;
    try {
      int? deletedCount = await db?.delete("password", where: "id = ?", whereArgs: [passwordId]);
      if(deletedCount != null && deletedCount > 0) {
        print("Count of deleted passwords: $deletedCount");
      }
      return deletedCount ?? 0;
    } on Exception catch (e) {
      print("Error deleting password with id: $passwordId");
      print(e);
    }

    return 0;
  }

  Future<int> deleteAllPassword() async {
    Database? db = await DBProvider.db.database;
    try {
      int? deletedCount = await db?.delete("password");
      if(deletedCount != null && deletedCount > 0) {
        print("Count of deleted passwords: $deletedCount");
      }
      return deletedCount ?? 0;
    } on Exception catch (e) {
      print("Error deleting all passwords");
      print(e);
    }

    return 0;
  }
}