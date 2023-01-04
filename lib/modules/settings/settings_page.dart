import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/confirmation_dalog.dart';
import 'package:password_manager/modules/settings/feature-protection.dart';
import 'package:password_manager/modules/settings/reset-super-password-form.dart';
import 'package:password_manager/modules/settings/update-super-password-form.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
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
          _buildNavTile("Feature Protection", Icons.lock, _navigateToFeatureProtection),
          _buildNavTile("Update Super Password", Icons.vpn_key, _navigateToUpdateSuperPassword),
          _buildNavTile("Reset Super Password", Icons.delete_forever, _handleResetPasswordClicked),
        ],
      )
    );
  }

  Widget _buildNavTile(String label, IconData icon, Function onClick) {
    return ListTile(
      title: Text(label),
      leading: Icon(icon),
      trailing: Icon(Icons.navigate_next),
      onTap: () { onClick(); },
    );
  }

  void _navigateToFeatureProtection() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return FeatureProtectionPage();
        })
    );
  }

  void _navigateToUpdateSuperPassword() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return UpdateSuperPasswordForm();
        })
    );
  }

  void _handleResetPasswordClicked() async {
    bool resetConfirmed = await showConfirmationDialog(context: context, body: "Resetting your super password will ask you to create a new super password.  Doing so will then delete all saved accounts.");
    if(resetConfirmed) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return ResetSuperPasswordForm();
          })
      );
    }
  }


}


