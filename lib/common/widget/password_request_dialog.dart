import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/utils/service_locator.dart';

bool showError = false;

Future<bool> showPasswordRequest({required BuildContext context}) async {
  showError = false;
  Widget dialog = passwordDialog(context);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
    barrierDismissible: true
  )
  .then((value) {
    return value == true;
  });
}


Widget doneButton(BuildContext dialogContext, BuildContext parentContext, StateSetter dialogSetState, TextEditingController input) {
  PasswordService passwordService = serviceLocator.get();
  return TextButton(
    child: Text(
      "Okay",
      // style: TextStyle(
      //   color: stmRed,
      //   fontWeight: FontWeight.w500,
      //   fontSize: 2.2 * SizeConfig.textMultiplier
      // ),
    ),
    onPressed: () {
      if(input.text.isNotEmpty && (passwordService.superPassword?.password ?? '') == input.text) {
        dialogSetState(() {
          showError = false;
        });
        Navigator.of(parentContext).pop(true);
      } else {
        dialogSetState(() {
          showError = true;
        });
      }
    },
  );
}

Widget cancelButton(BuildContext parentContext) {
  PasswordService passwordService = serviceLocator.get();
  return TextButton(
    child: Text(
      "Cancel",
      // style: TextStyle(
      //   color: stmRed,
      //   fontWeight: FontWeight.w500,
      //   fontSize: 2.2 * SizeConfig.textMultiplier
      // ),
    ),
    onPressed: () {
      Navigator.of(parentContext).pop(false);
    },
  );
}



Widget passwordDialog(BuildContext parentContext) {
  TextEditingController passwordController = new TextEditingController();
  bool isPasswordVisible = false;

  return StatefulBuilder(
    builder: (dialogContext, dialogSetState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // backgroundColor: stmGradientEnd,
        title: Text(
          "Enter Super Password",
          // style: TextStyle(
          //     fontWeight: FontWeight.w400,
          //     fontSize: 2.6 * SizeConfig.textMultiplier
          // ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                  // labelText: "Password",
                  hintText: "Type Super Password",
                  // errorText: _passwordInputError.isEmpty ? null : _passwordInputError,
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      dialogSetState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    color: Colors.black45,
                    focusColor: Colors.black45,
                    disabledColor: Colors.black45,
                  )
              ),
              keyboardType: TextInputType.text,
              // textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 8),
            Text(
              showError ? "Password incorrect" : '',
              style: TextStyle(
                color: Colors.redAccent
              ),
            )
          ],
        ),
        actions: [cancelButton(parentContext), doneButton(dialogContext, parentContext, dialogSetState, passwordController)],
      );
    }
  );
}