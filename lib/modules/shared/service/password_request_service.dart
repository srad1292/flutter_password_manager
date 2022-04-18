import 'package:password_manager/modules/shared/dao/password_request_dao.dart';
import 'package:password_manager/modules/shared/model/password_request.dart';

class PasswordRequestService {

  List<PasswordRequest> requestSettings = [];
  PasswordRequestDao _passwordRequestDao = new PasswordRequestDao();

  Future<List<PasswordRequest>> getRequestSettings() async {
    if(requestSettings.length > 0) {
      return this.requestSettings;
    }
    List<PasswordRequest> settings = await _passwordRequestDao.getPasswordRequestSettings();
    this.requestSettings = new List.from(settings);
    return this.requestSettings;
  }

  Future<bool> updateRequestSetting(PasswordRequest requestSetting) async {
    bool succeeded = await _passwordRequestDao.updatePasswordRequestSetting(requestSetting);

    if(succeeded) {
      int cacheIndex = this.requestSettings.indexWhere((element) => element.requestName == requestSetting.requestName);
      if(cacheIndex >= 0) {
        this.requestSettings[cacheIndex] = requestSetting;
      } else {
        this.requestSettings.add(requestSetting);
      }
    }

    return succeeded;
  }

}