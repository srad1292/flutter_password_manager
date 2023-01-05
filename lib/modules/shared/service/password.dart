
import 'package:password_manager/modules/shared/dao/password.dart';
import 'package:password_manager/modules/shared/dao/super_password_dao.dart';
import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/super_password/page/super_password.dart';

class PasswordService {

  late List<Password> passwords;
  late PasswordDao _passwordDao;
  late SuperPasswordDao _superPasswordDao;
  SuperPassword? superPassword;
  bool hasResetSuperPassword = false;

  PasswordService() {
    this.passwords = [];
    this._passwordDao = new PasswordDao();
    this._superPasswordDao = new SuperPasswordDao();
  }

  PasswordService.from(List<Password> passwords) {
    this.passwords = List.from(passwords);
    this._passwordDao = new PasswordDao();
    this._superPasswordDao = new SuperPasswordDao();
  }


  Future<SuperPassword?> getSuperPassword() async {
    return await this._superPasswordDao.getSuperPassword();
  }

  Future<SuperPassword?> createSuperPassword(SuperPassword password) async {
    int id = await this._superPasswordDao.addOrReplacePassword(password);
    print("Create super password ID: $id");
    if(id != -1) {
      password.id = id;
      return password;
    }

    return null;
  }

  Future<SuperPassword> updateSuperPassword(SuperPassword password) async {
    int id = await this._superPasswordDao.addOrReplacePassword(password);
    print("Update super password ID: $id");
    if(id != 0) {
      password.id = id;
    }
    this.superPassword = new SuperPassword.clone(password);
    return password;
  }

  Future<bool> resetSuperPassword(SuperPassword password) async {
    int newId = await this._superPasswordDao.resetSuperPassword(password);
    bool didReset = newId >= 0;
    print("Did i reset? $didReset");
    if(didReset) {
      this.superPassword = new SuperPassword.clone(password);
      this.superPassword?.id = newId;
      this.hasResetSuperPassword = true;
    }
    return didReset;
  }

  Future<List<Password>> getPasswordsFromPersistence({bool showSecret = false, String accountSearch = ''}) async {
    return await this._passwordDao.getAllPasswords(showSecret: showSecret, accountSearch: accountSearch);
  }

  Future<Password?> getPasswordById({int passwordId = 0}) async {
    return await this._passwordDao.getPasswordById(passwordId: passwordId);
  }

  Future<Password?> createPassword(Password password) async {
    int id = await this._passwordDao.addOrReplacePassword(password);
    print("Create password ID: $id");
    if(id != -1) {
      password.id = id;
      return password;
    }

    return null;
  }

  Future<Password> updatePassword(Password password) async {
    int id = await this._passwordDao.addOrReplacePassword(password);
    print("Update password ID: $id");
    if(id != 0) {
      password.id = id;
    }
    return password;
  }

  Future<int> deletePassword({int passwordID = -1}) async {
    int deletedCount = await this._passwordDao.deletePassword(passwordId: passwordID);
    return deletedCount;
  }

  Future<int> deleteAllPasswords() async {
    int deletedCount = await this._passwordDao.deleteAllPassword();
    return deletedCount;
  }
}