import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog({required BuildContext context, required String body}) async {
  Widget dialog = _confirmationDialog(context, body);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
      barrierDismissible: false
  )
      .then((value) {
    return value == true;
  });
}

Widget cancelButton(BuildContext context) {
  return TextButton(
    child: Text(
      "Cancel",
      style: TextStyle(
        color: Colors.redAccent,
        // fontWeight: FontWeight.w500,
        // fontSize: 2.2 * SizeConfig.textMultiplier
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop(false);
    },
  );
}

Widget confirmButton(BuildContext context) {
  return TextButton(
    child: Text(
      "Confirm",
      // style: TextStyle(
      //   color: stmRed,
      //   fontWeight: FontWeight.w500,
      //   fontSize: 2.2 * SizeConfig.textMultiplier
      // ),
    ),
    onPressed: () {
      Navigator.of(context).pop(true);
    },
  );
}

Widget _confirmationDialog(BuildContext context, String body) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    // backgroundColor: stmGradientEnd,
    title: Text(
      "Confirmation",
      // style: TextStyle(
      //     fontWeight: FontWeight.w400,
      //     fontSize: 2.6 * SizeConfig.textMultiplier
      // ),
      ),
    content: Text(body),
    actions: [cancelButton(context), confirmButton(context)],
  );
}