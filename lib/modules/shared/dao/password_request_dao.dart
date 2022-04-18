import 'package:password_manager/modules/shared/model/password_request.dart';
import 'package:password_manager/utils/database.dart';
import 'package:password_manager/utils/database_tables.dart';
import 'package:sqflite/sqflite.dart';

class PasswordRequestDao {

  PasswordRequestDao();

  Future<List<PasswordRequest>> getPasswordRequestSettings() async {
    Database? db = await DBProvider.db.database;

    try {
      List<Map<String, dynamic>>? dbPasswordRequestSettings = await db?.query(DatabaseTables.PASSWORD_REQUEST_SETTINGS);
      if(dbPasswordRequestSettings != null && dbPasswordRequestSettings.length > 0) {
        return List.generate(dbPasswordRequestSettings.length, (index) {
          return new PasswordRequest.fromPersistence(dbPasswordRequestSettings[index]);
        });
      }
      return [];
    } catch(error) {
      print("Error getting password request settings");
      print(error);
    }
    return [];
  }

  Future<bool> updatePasswordRequestSetting(PasswordRequest setting) async {
    Database? db = await DBProvider.db.database;
    try {
      int? updatedCount = await db?.update(
          DatabaseTables.PASSWORD_REQUEST_SETTINGS,
          setting.toPersistence(),
          where: "request_name = ?",
          whereArgs: [setting.requestName],
          conflictAlgorithm: ConflictAlgorithm.replace
      );
      return updatedCount != null && updatedCount > 0;
    } catch(error) {
      print("Error updating password setting");
      print(error);
    }
    return false;
  }

}