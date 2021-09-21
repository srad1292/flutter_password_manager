import 'package:password_manager/modules/shared/dao/password.dart';
import 'package:password_manager/modules/shared/model/password.dart';

class PasswordService {

  List<Password> passwords;
  PasswordDao _passwordDao;

  PasswordService() {
    this.passwords = [];
    this._passwordDao = new PasswordDao();
  }

  PasswordService.from(List<Password> passwords) {
    this.passwords = List.from(passwords);
    this._passwordDao = new PasswordDao();
  }

  Future<List<Password>> getPasswordsFromPersistence({String accountSearch = ''}) async {
    return await this._passwordDao.getAllPasswords(accountSearch: accountSearch);
  }

  Future<Password> getPasswordById({int passwordId = 0}) async {
    return await this._passwordDao.getPasswordById(passwordId: passwordId);
  }

  Future<Password> createPassword(Password password) async {
    int id = await this._passwordDao.addOrReplacePassword(password);
    if(id != 0) {
      password.id = id;
    }
    return password;
  }

  Future<Password> updatePassword(Password password) async {
    int id = await this._passwordDao.addOrReplacePassword(password);
    if(id != 0) {
      password.id = id;
    }
    return password;
  }

  Future<int> deletePassword({int passwordID = 0}) async {
    int deletedCount = await this._passwordDao.deletePassword(passwordId: passwordID);
    return deletedCount;
  }

  Future<int> deleteAllPasswords() async {
    int deletedCount = await this._passwordDao.deleteAllPassword();
    return deletedCount;
  }
}