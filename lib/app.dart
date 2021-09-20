import 'package:flutter/material.dart';
import 'package:password_manager/styling/app_theme.dart';
import 'package:password_manager/utils/size_config.dart';

import 'modules/super_password/page/initialize_super_password.dart';

class PasswordManagerApp extends StatefulWidget {
  @override
  _PasswordManagerAppState createState() => _PasswordManagerAppState();
}

class _PasswordManagerAppState extends State<PasswordManagerApp> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              title: 'Flutter Demo',
              theme: AppTheme.lightTheme,
              home: InitializeSuperPassword(),
            );
          }
        );
      }
    );
  }
}
