import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            child: Center(child: Text("Settings page coming soon."))
          ),
        ),
      ),
    );
  }
}
