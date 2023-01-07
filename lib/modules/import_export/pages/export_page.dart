
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:password_manager/common/widget/password_manager_dialog.dart';
import 'package:password_manager/common/widget/password_request_dialog.dart';
import 'package:password_manager/modules/import_export/services/export_service.dart';
import 'package:password_manager/modules/import_export/widgets/email_address_dialog.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/shared/service/settings.dart';
import 'package:password_manager/utils/service_locator.dart';
import 'package:path_provider/path_provider.dart';


import '../models/exportdata.dart';


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
                      _buildExportToFileButton(),
                      _buildExportViaEmailButton()
                    ],
                  )
              ),
              resizeToAvoidBottomInset: false,
            )
        )
    );
  }

  Future<ExportData?> getExportData() async {
    if(_settingsService.getSettings().guardExportPasswords) {
      bool canExport = await showPasswordRequest(context: context);
      if(!canExport) { return null; }
    }

    ExportService exportService = new ExportService();
    ExportData data = await exportService.getExportData();

    return data;
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

  Future<void> _writeDataToFile(ExportData data) async {
    try {
      File? file = await _getBackupDataFile('/storage/emulated/0/Download', data);
      if(file == null) { return; }
      print("====WRITING TO FILE====");
      print(jsonEncode(data));
      await file.writeAsString(jsonEncode(data));
      await showSuccessDialog(context: context, title: "Success", body: "${data.accounts.length} accounts backed up successfully.");
    } catch (e) {
      showErrorDialog(context: context, body: "Failed to write data to file.");
    }
  }

  Future<File?> _getBackupDataFile(String pathToTryFirst, ExportData data) async {
    Directory? directory = Directory(pathToTryFirst);
    if (!await directory.exists()) directory = await getExternalStorageDirectory();
    if ((await directory?.exists() ?? false) == false) {
      showErrorDialog(context: context, body: "Unable to find directory to save file.");
      return null;
    }

    return File("${directory?.path}/pm-account-backup.json");


  }

  Widget _buildExportViaEmailButton() {
    return ElevatedButton(
      onPressed: backingUp ? null : () async {
        ExportData? data = await getExportData();
        if(data == null) { return; }

        _sendEmail(data);
      },
      child: Text("Export via Email"),
    );
  }

  Future<void> _sendEmail(ExportData data) async {
    try {
      String? recipient = await showEmailAddressDialog(context: context);
      if((recipient ?? '').isEmpty) { return; }

      Directory? appDirectory = await getExternalStorageDirectory();
      File? file = await _getBackupDataFile(appDirectory?.path ?? '', data);
      if(file == null) { return; }

      final Email email = Email(
        body: 'You are receiving this email because you backed-up accounts from your PM app',
        subject: 'PM Accounts Backup',
        recipients: [recipient ?? ''],
        cc: [],
        bcc: [],
        attachmentPaths: [file.path],
        isHTML: false,
      );
      try {
        await FlutterEmailSender.send(email);
        await showSuccessDialog(context: context, title: "Success", body: "${data.accounts.length} accounts backed-up successfully.");
      } catch (e) {
        showErrorDialog(context: context, body: "Unable to open email client. Make sure to set up an email client");
      }

    } catch (e) {
      showErrorDialog(context: context, body: "Failed to write data to file.");
    }

  }


}
