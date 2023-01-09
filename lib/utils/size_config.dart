import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;
  static double _blockWidth = 3.84;
  static double _blockHeight = 7.84;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight == 0 ? 7.84 : _blockHeight;
    imageSizeMultiplier = _blockWidth == 0 ? 3.84 : _blockWidth;
    heightMultiplier = _blockHeight == 0 ? 7.84 : _blockHeight;
    widthMultiplier = _blockWidth == 0 ? 3.84 : _blockWidth;

    print("(Block Width: $_blockWidth, Block Height: $_blockHeight");
    print(_screenWidth);
  }
}