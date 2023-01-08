import 'package:password_manager/modules/import_export/models/exportdata.dart';
import 'package:password_manager/modules/shared/dao/password.dart';
import 'package:password_manager/modules/shared/dao/super_password_dao.dart';
import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/shared/service/encryptor_service.dart';
import 'package:password_manager/modules/super_password/page/super_password.dart';

class ExportService {

  late PasswordDao _passwordDao;
  late SuperPasswordDao _superPasswordDao;

  ExportService() {
    this._passwordDao = new PasswordDao();
    this._superPasswordDao = new SuperPasswordDao();
  }

  Future<ExportData> getExportData() async {
    SuperPassword superPassword = (await _superPasswordDao.getSuperPassword())!;
    SuperPassword encryptedSuper = await _encryptSuperPassword(superPassword);
    List<Password> accounts = await _passwordDao.getAllPasswords(showSecret: true);
    List<Password> encrypted = await _encryptAccounts(accounts);
    return new ExportData(encryptedSuper, encrypted);
  }

  Future<SuperPassword> _encryptSuperPassword(SuperPassword superPassword) async {
    EncryptorService encryptorService = new EncryptorService();
    await encryptorService.createEncryptor();

    SuperPassword encrypted;
    encrypted = SuperPassword.clone(superPassword);
    encrypted.password = encryptorService.encryptString(superPassword.password);

    return encrypted;
  }

  Future<List<Password>> _encryptAccounts(List<Password> accounts) async {
    EncryptorService encryptorService = new EncryptorService();
    await encryptorService.createEncryptor();

    Password tempPassword;
    List<Password> encryptedAccounts = accounts.map((e) {
      tempPassword = Password.clone(e);
      tempPassword.accountName = encryptorService.encryptString(e.accountName);
      tempPassword.password = encryptorService.encryptString(e.password);
      return tempPassword;
    }).toList();

    return encryptedAccounts;
  }
}