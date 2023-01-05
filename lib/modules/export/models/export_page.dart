
import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/password_request_dialog.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/shared/service/settings.dart';
import 'package:password_manager/utils/service_locator.dart';


import 'exportdata.dart';


class ExportDataPage extends StatefulWidget {
  @override
  _ExportDataPageState createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  late PasswordService _passwordService;
  late SettingsService _settingsService;

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
      onPressed: () async {
        ExportData? data = await getExportData();
        if(data == null) { return; }
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

    print("====TESTING DECRYPT====");
    ExportData decrypted = await _passwordService.decryptData(data);
    print(decrypted.toJson());


  }


}
