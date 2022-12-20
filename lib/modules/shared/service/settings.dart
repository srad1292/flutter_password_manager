import 'package:password_manager/modules/shared/model/settings.dart';
import 'package:password_manager/modules/shared/password_request_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late Settings _settings;

  SettingsService() {
    this._settings = new Settings();
  }

  Future<Settings> restoreSettings() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _settings = new Settings.init(
          guardChangeSettings: preferences.getBool(PasswordRequestOptions.changePasswordRequestSettings) ?? true,
          guardViewPassword: preferences.getBool(PasswordRequestOptions.viewPassword) ?? true,
          guardAddPassword: preferences.getBool(PasswordRequestOptions.addPassword) ?? true,
          guardEditPassword: preferences.getBool(PasswordRequestOptions.updatePassword) ?? true,
          guardDeletePassword: preferences.getBool(PasswordRequestOptions.deletePassword) ?? true,
          guardShowSecretPasswords: preferences.getBool(PasswordRequestOptions.showSecretPasswords) ?? true,
          guardImportPasswords: preferences.getBool(PasswordRequestOptions.importPasswords) ?? true,
          guardExportPasswords: preferences.getBool(PasswordRequestOptions.exportPasswords) ?? true);
    } catch(e) {
      _settings = new Settings();
    }
    return _settings;
  }

  Settings getSettings() {
    return this._settings;
  }

  Future<void> updateSettings(Settings settings) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool(PasswordRequestOptions.changePasswordRequestSettings, settings.guardChangeSettings);
      preferences.setBool(PasswordRequestOptions.viewPassword, settings.guardViewPassword);
      preferences.setBool(PasswordRequestOptions.addPassword, settings.guardAddPassword);
      preferences.setBool(PasswordRequestOptions.updatePassword, settings.guardEditPassword);
      preferences.setBool(PasswordRequestOptions.deletePassword, settings.guardDeletePassword);
      preferences.setBool(PasswordRequestOptions.showSecretPasswords, settings.guardShowSecretPasswords);
      preferences.setBool(PasswordRequestOptions.importPasswords, settings.guardImportPasswords);
      preferences.setBool(PasswordRequestOptions.exportPasswords, settings.guardExportPasswords);
    } catch(e) {
    }
    _settings = Settings.from(settings);
  }


}