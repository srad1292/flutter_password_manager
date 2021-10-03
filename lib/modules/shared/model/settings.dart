class Settings {
  bool guardChangeSettings;
  bool guardViewPassword;
  bool guardAddPassword;
  bool guardEditPassword;
  bool guardDeletePassword;
  bool guardShowSecretPasswords;
  bool guardImportPasswords;
  bool guardExportPasswords;

  Settings();

  Settings.init({bool guardChangeSettings, bool guardViewPassword,
    bool guardAddPassword, bool guardEditPassword,
    bool guardDeletePassword, bool guardShowSecretPasswords,
    bool guardImportPasswords, bool guardExportPasswords})
  {
    this.guardChangeSettings = guardChangeSettings;
    this.guardViewPassword = guardViewPassword;
    this.guardAddPassword = guardAddPassword;
    this.guardEditPassword = guardEditPassword;
    this.guardDeletePassword = guardDeletePassword;
    this.guardShowSecretPasswords = guardShowSecretPasswords;
    this.guardImportPasswords = guardImportPasswords;
    this.guardExportPasswords = guardExportPasswords;
  }

  Settings.from(Settings settings) {
    this.guardChangeSettings = settings.guardChangeSettings;
    this.guardViewPassword = settings.guardViewPassword;
    this.guardAddPassword = settings.guardAddPassword;
    this.guardEditPassword = settings.guardEditPassword;
    this.guardDeletePassword = settings.guardDeletePassword;
    this.guardShowSecretPasswords = settings.guardShowSecretPasswords;
    this.guardImportPasswords = settings.guardImportPasswords;
    this.guardExportPasswords = settings.guardExportPasswords;
  }

  @override
  String toString() {
    return "{ guardChangeSettings: $guardChangeSettings, guardViewPassword: $guardViewPassword, "
     + "guardAddPassword: $guardAddPassword, guardEditPassword: + $guardEditPassword, "
     + "guardDeletePassword: $guardDeletePassword, guardShowSecretPasswords: $guardShowSecretPasswords, "
     + "guardImportPasswords: $guardImportPasswords, guardExportPasswords: $guardExportPasswords}";
  }


}