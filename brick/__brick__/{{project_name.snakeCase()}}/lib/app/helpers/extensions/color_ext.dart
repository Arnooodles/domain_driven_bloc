import 'package:flutter/material.dart';

extension ColorExt on Color {
  String _generateAlpha({required int alpha, required bool withAlpha}) =>
      withAlpha ? alpha.toRadixString(16).padLeft(2, '0') : '';

  String toHexString({bool hashSign = false, bool withAlpha = false}) {
    final String alpha =
        _generateAlpha(alpha: _floatToInt8(a), withAlpha: withAlpha);
    final String red = _floatToInt8(r).toRadixString(16).padLeft(2, '0');
    final String green = _floatToInt8(g).toRadixString(16).padLeft(2, '0');
    final String blue = _floatToInt8(b).toRadixString(16).padLeft(2, '0');

    return '${hashSign ? '#' : ''}$alpha$red$green$blue'.toUpperCase();
  }

  int _floatToInt8(double value) => (value * 255.0).round() & 0xff;

  static Color fromHexString(String hexString) {
    final StringBuffer buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
