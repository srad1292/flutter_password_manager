import 'package:flutter/material.dart';

Future<void> showErrorDialog({required BuildContext context, required String body}) async {
  Widget dialog = _errorDialog(context, body);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
      barrierDismissible: true
  )
  .then((value) { return;});
}

Widget confirmButton(BuildContext context) {
  return TextButton(
    child: Text(
      "Ok",
      // style: TextStyle(
      //   color: stmRed,
      //   fontWeight: FontWeight.w500,
      //   fontSize: 2.2 * SizeConfig.textMultiplier
      // ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

Widget _errorDialog(BuildContext context, String body) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    // backgroundColor: stmGradientEnd,
    title: Text(
      "Error",
      // style: TextStyle(
      //     fontWeight: FontWeight.w400,
      //     fontSize: 2.6 * SizeConfig.textMultiplier
      // ),
      ),
    content: Text(body),
    actions: [confirmButton(context)],
  );
}