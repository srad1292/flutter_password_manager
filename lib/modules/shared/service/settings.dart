import 'package:password_manager/modules/shared/model/settings.dart';

class SettingsService {
  Settings _settings;

  SettingsService() {
    this._settings = new Settings();
  }

  Settings getSettings() {
    return this._settings;
  }

  void updateSettings(Settings settings) {
    _settings = Settings.from(settings);
  }


}