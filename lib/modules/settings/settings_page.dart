import 'package:flutter/material.dart';
import 'package:password_manager/modules/shared/model/settings.dart';
import 'package:password_manager/modules/shared/service/settings.dart';
import 'package:password_manager/utils/service_locator.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _changeSettingsToggle = true;
  bool _viewPasswordToggle = true;
  bool _addPasswordToggle = true;
  bool _editPasswordToggle = true;
  bool _deletePasswordToggle = true;
  bool _showSecretToggle = true;
  bool _importPasswordsToggle = true;
  bool _exportPasswordsToggle = true;

  SettingsService _settingsService;

  @override
  void initState() {
    super.initState();
    _settingsService = serviceLocator.get<SettingsService>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
            child: _buildSettingsContent(context)
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTitle(),
          ..._buildSettingsList(),
          _buildSettingsSaveButton(),
          _buildApplicationActionsSection(),
        ],
      )
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "When to Request Password",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }

  List<Widget> _buildSettingsList() {

    return [
      ..._buildSettingToggle("Change Settings", _changeSettingsToggle, (newValue) {
        setState(() {
          _changeSettingsToggle = newValue;
        });
      }),
      ..._buildSettingToggle("View Password", _viewPasswordToggle, (newValue) {
        setState(() {
          _viewPasswordToggle = newValue;
        });
      }),
      ..._buildSettingToggle("Add Password", _addPasswordToggle, (newValue) {
        setState(() {
          _addPasswordToggle = newValue;
        });
      }),
      ..._buildSettingToggle("Edit Password", _editPasswordToggle, (newValue) {
        setState(() {
          _editPasswordToggle = newValue;
        });
      }),
      ..._buildSettingToggle("Delete Password", _deletePasswordToggle, (newValue) {
        setState(() {
          _deletePasswordToggle = newValue;
        });
      }),
      ..._buildSettingToggle("Show Secret Passwords", _showSecretToggle, (newValue) {
        setState(() {
          _showSecretToggle = newValue;
        });
      }),
      ..._buildSettingToggle("Import Passwords", _importPasswordsToggle, (newValue) {
        setState(() {
          _importPasswordsToggle = newValue;
        });
      }),
      ..._buildSettingToggle("Export Passwords", _exportPasswordsToggle, (newValue) {
        setState(() {
          _exportPasswordsToggle = newValue;
        });
      }),
    ];
  }

  List<Widget> _buildSettingToggle(String title, bool value, Function(bool) onChanged) {
    return [
      SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blueAccent,
        activeTrackColor: Colors.lightBlueAccent,
        inactiveThumbColor: Colors.blueAccent,
        inactiveTrackColor: Colors.black12,
      ),
      Divider(thickness: 2,)
    ];
  }

  Widget _buildSettingsSaveButton() {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 18),
      child: ElevatedButton(
        onPressed: () async {
          Settings newSettings = new Settings.init(
            guardChangeSettings: _changeSettingsToggle, guardAddPassword: _addPasswordToggle,
            guardViewPassword: _viewPasswordToggle, guardEditPassword: _editPasswordToggle,
            guardDeletePassword: _deletePasswordToggle, guardShowSecretPasswords: _showSecretToggle,
            guardImportPasswords: _importPasswordsToggle, guardExportPasswords: _exportPasswordsToggle
          );

          print("New Settings");
          print(newSettings.toString());

          _settingsService.updateSettings(newSettings);
          print("Updated Settings");
          print(_settingsService.getSettings().toString());
        },
        child: Text("Save Password"),
      ),
    );
  }

  Widget _buildApplicationActionsSection() {
    return Container();
  }
}


