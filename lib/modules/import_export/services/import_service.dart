import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:password_manager/common/widget/imported_super_request.dart';
import 'package:password_manager/modules/import_export/models/exportdata.dart';
import 'package:password_manager/modules/shared/service/encryptor_service.dart';

class ImportService {

  late BuildContext context;

  ImportService(BuildContext context) { this.context = context; }

  Future<bool> importData() async {
    File? file = await _selectBackupFile();
    if(file == null) { return false; }

    ExportData? data = await _parseData(file);
    if(data == null) { return false; }


    bool confirmedSuperPassword = await showImportedPasswordRequest(context: context, importedSuperPassword: data.superPassword.password);
    if(!confirmedSuperPassword) { return false; }

    // add accounts to database

    // show confirmation dialog if successful

    return false; // return accountsImported;
  }

  Future<File?> _selectBackupFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        String path = result.files.single.path ?? '';
        if((path).endsWith(".json")) {
          return File(path);
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
      print("FILE DATA");
      print(fileData);
      print("Going to decode");
      jsonEncode(jsonDecode(fileData));
      print("decoded");
      ExportData data = ExportData.fromJson(jsonDecode(fileData));
      ExportData decrypted = await _decryptExportData(data);
      print("Decrypted imported data");
      print(decrypted.toJson());
      return decrypted;
    } catch(e, stacktrace) {
      print(e);
      print(stacktrace);
      await showErrorDialog(context: context, body: "Data in selected file is not proper format");
      return null;
    }
  }

  Future<ExportData> _decryptExportData(ExportData data) async {
    EncryptorService encryptorService = new EncryptorService();
    await encryptorService.createEncryptor();

    ExportData decrypted = ExportData(data.superPassword, data.accounts);
    print("Super password before decryption");
    print(data.superPassword.password);
    decrypted.superPassword.password = encryptorService.decryptString(decrypted.superPassword.password);

    decrypted.accounts.forEach((element) {
      element.password = encryptorService.decryptString(element.password);
      element.accountName = encryptorService.decryptString(element.accountName);
    });

    return decrypted;
  }





}