import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/app.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => PasswordManagerApp()
    )
  );
}



