import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/jumping_dot_indicator.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({Key? key}) : super(key: key);

  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
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
