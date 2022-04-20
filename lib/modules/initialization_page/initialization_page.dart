import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:password_manager/common/widget/jumping_dot_indicator.dart';
import 'package:password_manager/modules/account_list/account_list_page.dart';
import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/super_password/page/initialize_super_password.dart';
import 'package:password_manager/utils/service_locator.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({Key? key}) : super(key: key);

  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _determineNavigationPath();
    });
  }

  void _determineNavigationPath() async {
    PasswordService passwordService = serviceLocator.get<PasswordService>();
    Password? password = await passwordService.getSuperPassword();

    if(password == null) {
      print("Failed to get password");
      // TODO: handle password retrieval error
    } else if(password.accountName.isEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return InitializeSuperPassword();
          })
      );
    } else {
      passwordService.superPassword = password;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return AccountListPage();
          })
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Password Manager",
                  style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Loading ",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    JumpingDotsProgressIndicator(
                      numberOfDots: 6,
                      fontSize: 20,
                      color: Colors.black,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
