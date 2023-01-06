import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:password_manager/common/widget/imported_super_request.dart';
import 'package:password_manager/modules/import_export/models/exportdata.dart';

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
        if((path).endsWith(".txt") || path.endsWith('.text')) {
          return File(path);
        } else {
          await showErrorDialog(context: context, body: "File extension should be .txt or .text");
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
      return data;
    } catch(e) {
      print(e);
      await showErrorDialog(context: context, body: "Data in selected file is not proper format");
      return null;
    }
  }





}