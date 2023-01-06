import 'package:flutter/material.dart';

Future<void> showSuccessDialog({required BuildContext context, required String title, required String body}) async {
  Widget dialog = _confirmationDialog(context, title, body);
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
      barrierDismissible: false
  );
}

Widget okButton(BuildContext context) {
  return TextButton(
    child: Text(
      "Ok",
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

Widget _confirmationDialog(BuildContext context, String title, String body) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    // backgroundColor: stmGradientEnd,
    title: Text(
      title,
      // style: TextStyle(
      //     fontWeight: FontWeight.w400,
      //     fontSize: 2.6 * SizeConfig.textMultiplier
      // ),
    ),
    content: Text(body),
    actions: [okButton(context)],
  );
}