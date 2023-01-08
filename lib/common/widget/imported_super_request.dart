import 'package:flutter/material.dart';

bool showError = false;

Future<bool> showImportedPasswordRequest({required BuildContext context, required String importedSuperPassword}) async {
  showError = false;
  Widget dialog = passwordDialog(context, importedSuperPassword);
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


Widget doneButton(BuildContext dialogContext, BuildContext parentContext, StateSetter dialogSetState, TextEditingController input, String importedSuperPassword) {
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
      if(input.text.isNotEmpty && importedSuperPassword == input.text) {
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



Widget passwordDialog(BuildContext parentContext, String importedSuperPassword) {
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
            "Enter Super Password from Imported Data",
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
          actions: [cancelButton(parentContext), doneButton(dialogContext, parentContext, dialogSetState, passwordController, importedSuperPassword)],
        );
      }
  );
}