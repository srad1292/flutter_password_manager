class Settings {
  late bool guardChangeSettings;
  late bool guardViewPassword;
  late bool guardAddPassword;
  late bool guardEditPassword;
  late bool guardDeletePassword;
  late bool guardShowSecretPasswords;
  late bool guardImportPasswords;
  late bool guardExportPasswords;

  Settings();

  Settings.init({required bool guardChangeSettings, required bool guardViewPassword,
    required bool guardAddPassword, required bool guardEditPassword,
    required bool guardDeletePassword, required bool guardShowSecretPasswords,
    required bool guardImportPasswords, required bool guardExportPasswords})
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