import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/super_password/page/super_password.dart';

class ExportData {
  late SuperPassword superPassword;
  late List<Password> accounts;

  ExportData(SuperPassword superPassword, List<Password> accounts) {
   this.superPassword = SuperPassword.clone(superPassword);
   this.accounts = accounts.map((e) => Password.clone(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['superPassword'] = this.superPassword.toPersistence();
    data['accounts'] = this.accounts.map((v) => v.toJson()).toList();
    return data;
  }
}