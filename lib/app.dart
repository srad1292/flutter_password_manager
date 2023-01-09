import 'package:flutter/material.dart';
import 'package:password_manager/modules/initialization_page/initialization_page.dart';
import 'package:password_manager/styling/app_theme.dart';
import 'package:password_manager/utils/size_config.dart';


class PasswordManagerApp extends StatefulWidget {
  @override
  _PasswordManagerAppState createState() => _PasswordManagerAppState();
}

class _PasswordManagerAppState extends State<PasswordManagerApp> {

  double lastHeight = -1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            if(lastHeight == 0 && SizeConfig.heightMultiplier != 0) {
              print("Height was 0 and now is not so I am rebuilding");
              setState(() {});
            }
            lastHeight = SizeConfig.heightMultiplier;
            return MaterialApp(
              title: 'Password Manager',
              theme: AppTheme.lightTheme,
              home: InitializationPage(),
            );
          }
        );
      }
    );
  }
}
