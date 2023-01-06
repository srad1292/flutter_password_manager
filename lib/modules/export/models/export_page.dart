
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:password_manager/common/widget/password_manager_dialog.dart';
import 'package:password_manager/common/widget/password_request_dialog.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/shared/service/settings.dart';
import 'package:password_manager/utils/service_locator.dart';
import 'package:path_provider/path_provider.dart';


import 'exportdata.dart';


class ExportDataPage extends StatefulWidget {
  @override
  _ExportDataPageState createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  late PasswordService _passwordService;
  late SettingsService _settingsService;

  bool backingUp = false;

  @override
  void initState() {
    super.initState();
    _settingsService = serviceLocator.get<SettingsService>();
    _passwordService = serviceLocator.get<PasswordService>();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
            onTap: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                  title: Text("Export Accounts")
              ),
              body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildExportToFileButton()
                    ],
                  )
              ),
              resizeToAvoidBottomInset: false,
            )
        )
    );
  }

  Widget _buildExportToFileButton() {
    return ElevatedButton(
      onPressed: backingUp ? null : () async {
        ExportData? data = await getExportData();
        if(data == null) { return; }

        _writeDataToFile(data);
      },
      child: Text("Export to File"),
    );
  }

  Future<ExportData?> getExportData() async {
    if(_settingsService.getSettings().guardExportPasswords) {
      bool canExport = await showPasswordRequest(context: context);
      if(!canExport) { return null; }
    }

    ExportData data = await _passwordService.getExportData();

    print("====GOT EXPORT DATA====");
    print(data.toJson());

    return data;
  }

  Future<void> _writeDataToFile(ExportData data) async {
    try {
      Directory? directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) directory = await getExternalStorageDirectory();
      if ((await directory?.exists() ?? false) == false) {
        showErrorDialog(context: context, body: "Unable to find directory to save file.");
      }

      File file = File("${directory?.path}/account-backup.txt");
      await file.writeAsString("${data.toJson()}");
      await showSuccessDialog(context: context, title: "Success", body: "${data.accounts.length} accounts backedup successfully.");
    } catch (e) {
      showErrorDialog(context: context, body: "Failed to write data to file.");
    }
  }


}
