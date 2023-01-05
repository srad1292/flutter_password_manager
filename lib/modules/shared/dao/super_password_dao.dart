import 'package:password_manager/modules/super_password/page/super_password.dart';
import 'package:password_manager/utils/database.dart';
import 'package:password_manager/utils/database_tables.dart';
import 'package:sqflite/sqflite.dart';

class SuperPasswordDao {

  SuperPasswordDao();

  Future<int> addOrReplacePassword(SuperPassword password) async {
    Database? db = await DBProvider.db.database;
    try {
      int? id = await db?.insert(DatabaseTables.SUPER_PASSWORD, password.toPersistence(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return id ?? -1;
    } catch(error) {
      print("Error adding or replacing super password");
      print(error);
    }
    return -1;
  }

  /// Returns super password if found, empty password if not, null if error
  Future<SuperPassword?> getSuperPassword() async {
    Database? db = await DBProvider.db.database;
    try {
      List<Map<String, dynamic>>? dbPasswords = await db?.query(
          DatabaseTables.SUPER_PASSWORD,
      );

      if(dbPasswords != null && dbPasswords.length > 0) {
        return List.generate(dbPasswords.length, (index) {
          return SuperPassword.fromPersistence(dbPasswords[index]);
        })[0];
      } else {
        return new SuperPassword();
      }
    } catch(error) {
      print("Error in getSuperPassword");
      print(error);
    }

    return null;
  }

  Future<int> deleteSuperPassword() async {
    Database? db = await DBProvider.db.database;
    try {
      int? deletedCount = await db?.delete(DatabaseTables.SUPER_PASSWORD);
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

  Future<int> resetSuperPassword(SuperPassword password) async {
    Database? db = await DBProvider.db.database;
    try {
      int id = -1;
      await db?.transaction((txn) async {
        id = await txn.insert(DatabaseTables.SUPER_PASSWORD, password.toPersistence(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        print("Updated super password. Id: $id");
        print("Time to delete");
        int deletedCount = await txn.delete(DatabaseTables.PASSWORD);
        print("Delete finished");
        print("Deleted password count: $deletedCount");
      });
      print("I am returning with value of: $id");
      return id;
    } catch(e) {
      print(e.toString());
      print("Reset super password failed");
      return -1;
    }
  }
}