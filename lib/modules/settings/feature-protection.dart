import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/password_request_dialog.dart';
import 'package:password_manager/modules/shared/model/settings.dart';
import 'package:password_manager/modules/shared/service/settings.dart';
import 'package:password_manager/utils/service_locator.dart';

class FeatureProtectionPage extends StatefulWidget {
  @override
  _FeatureProtectionPageState createState() => _FeatureProtectionPageState();
}

class _FeatureProtectionPageState extends State<FeatureProtectionPage> {
  late bool _changeSettingsToggle;
  late bool _viewPasswordToggle;
  late bool _addPasswordToggle;
  late bool _editPasswordToggle;
  late bool _deletePasswordToggle;
  late bool _showSecretToggle;
  late bool _importPasswordsToggle;
  late bool _exportPasswordsToggle;

  late SettingsService _settingsService;

  @override
  void initState() {
    super.initState();
    _settingsService = serviceLocator.get<SettingsService>();
    Settings initial = _settingsService.getSettings();
    _changeSettingsToggle = initial.guardChangeSettings;
    _viewPasswordToggle = initial.guardViewPassword;
    _addPasswordToggle = initial.guardAddPassword;
    _editPasswordToggle = initial.guardEditPassword;
    _deletePasswordToggle = initial.guardDeletePassword;
    _showSecretToggle = initial.guardShowSecretPasswords;
    _importPasswordsToggle = initial.guardImportPasswords;
    _exportPasswordsToggle = initial.guardExportPasswords;
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
            title: Text("Feature Protection"),
          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              child: _buildFeaturesContent(context)
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesContent(BuildContext context) {
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
          style: Theme.of(context).textTheme.headlineSmall,
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
      ..._buildSettingToggle("Add/Edit Password", _addPasswordToggle, (newValue) {
        setState(() {
          _addPasswordToggle = newValue;
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
        inactiveThumbColor: Theme.of(context).toggleableActiveColor,
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
          if(_settingsService.getSettings().guardChangeSettings == true) {
            bool confirmed = await showPasswordRequest(context: context);
            if(!confirmed) {
              return;
            }
          }

          Settings newSettings = new Settings.init(
              guardChangeSettings: _changeSettingsToggle, guardAddPassword: _addPasswordToggle,
              guardViewPassword: _viewPasswordToggle, guardEditPassword: _editPasswordToggle,
              guardDeletePassword: _deletePasswordToggle, guardShowSecretPasswords: _showSecretToggle,
              guardImportPasswords: _importPasswordsToggle, guardExportPasswords: _exportPasswordsToggle
          );


          await _settingsService.updateSettings(newSettings);

          Navigator.of(context).pop();
        },
        child: Text("Save Settings"),
      ),
    );
  }

  Widget _buildApplicationActionsSection() {
    return Container();
  }
}


