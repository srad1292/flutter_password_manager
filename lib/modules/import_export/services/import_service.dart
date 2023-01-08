import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:password_manager/common/widget/imported_super_request.dart';
import 'package:password_manager/common/widget/password_manager_dialog.dart';
import 'package:password_manager/modules/import_export/models/exportdata.dart';
import 'package:password_manager/modules/shared/service/encryptor_service.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/utils/service_locator.dart';

class ImportService {

  late BuildContext context;

  ImportService(BuildContext context) { this.context = context; }

  Future<bool> importData() async {
    File? file = await _selectBackupFile();
    if(file == null) { return false; }

    ExportData? data = await _parseData(file);
    file.delete();
    if(data == null) { return false; }


    bool confirmedSuperPassword = await showImportedPasswordRequest(context: context, importedSuperPassword: data.superPassword.password);
    if(!confirmedSuperPassword) { return false; }

    // add accounts to database
    PasswordService passwordService = serviceLocator.get<PasswordService>();
    int insertedCount = await passwordService.bulkInsertPasswords(data.accounts);

    // show confirmation dialog if successful
    if(insertedCount >= 0) {
      await showSuccessDialog(context: context, title: "Import Success", body: "Imported $insertedCount accounts from backup.");
      return true;
    } else {
      await showErrorDialog(context: context, body: "Saving accounts from backup failed");
      return false;
    }

  }

  Future<File?> _selectBackupFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        List<File> files = result.paths.map((path) { return File(path ?? '');}).toList();
        if((files[0].path).endsWith(".json")) {
          return files[0];
        } else {
          await showErrorDialog(context: context, body: "File extension should be .json");
          return null;
        }
      } else {
        // User canceled the picker
        return null;
      }
    } catch(e) {
      await showErrorDialog(context: context, body: "The file picker failed. Please try again.");
      return null;
    }

  }

  Future<ExportData?> _parseData(File file) async {
    try {
      var fileData = await file.readAsString();
      jsonEncode(jsonDecode(fileData));
      ExportData data = ExportData.fromJson(jsonDecode(fileData));
      ExportData decrypted = await _decryptExportData(data);
      return decrypted;
    } catch(e) {
      await showErrorDialog(context: context, body: "Data in selected file is not proper format");
      return null;
    }
  }

  Future<ExportData> _decryptExportData(ExportData data) async {
    EncryptorService encryptorService = new EncryptorService();
    await encryptorService.createEncryptor();

    ExportData decrypted = ExportData(data.superPassword, data.accounts);
    decrypted.superPassword.password = encryptorService.decryptString(decrypted.superPassword.password);

    decrypted.accounts.forEach((element) {
      element.id = null;
      element.password = encryptorService.decryptString(element.password);
      element.accountName = encryptorService.decryptString(element.accountName);
    });

    return decrypted;
  }





}