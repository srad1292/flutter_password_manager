import 'package:flutter/material.dart';

class JumpingDotAnimation extends AnimatedWidget {
  final Color color;
  final double fontSize;

  JumpingDotAnimation({Key? key, required Animation<double> animation, this.color = Colors.black, this.fontSize = 12}) : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Container(
      height: 30 + (10 * animation.value),
      child: Text(
        '.',
        style: TextStyle(color: color, fontSize: fontSize),
      ),
    );
  }
}
