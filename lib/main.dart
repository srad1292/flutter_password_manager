import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'utils/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => PasswordManagerApp()
    )
  );
}



