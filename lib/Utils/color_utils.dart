import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:noamooz/Utils/storage_utils.dart';

class ColorUtil {
  late final Color color;

  ColorUtil([int? colorValue]) {
    if (colorValue is int) {
      color = Color(colorValue);
    }
  }

  MaterialColor toMaterial() {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  factory ColorUtil.fromColor(Color color) {
    return ColorUtil()..color = color;
  }
  static Color fromHex(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e){
      return ColorUtils.black;
    }
  }
  static List<Shadow> outlinedText({double strokeWidth = 2, Color strokeColor = Colors.black, int precision = 5}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for(int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      }
    }
    return result.toList();
  }
}

class ColorUtils {
  static MaterialColor white = ColorUtil(0xffffffff).toMaterial();
  static MaterialColor black = ColorUtil(0xff222831).toMaterial();
  static Color textColor = ColorUtils.gray.shade200;
  static Color textBlack = ColorUtils.black.withOpacity(0.7);
  static MaterialColor blue = ColorUtil(0xff2D4059).toMaterial();
  static MaterialColor yellow = ColorUtil(0xffFBCB0A).toMaterial();
  static MaterialColor orange = ColorUtil(0xffFF5722).toMaterial();
  static MaterialColor green = ColorUtil(0xff00C897).toMaterial();
  static MaterialColor red = ColorUtil(0xffef1f1f).toMaterial();
  static MaterialColor gray = ColorUtil(0xff424242).toMaterial();
  static MaterialColor purple = ColorUtil(0xff9818D6).toMaterial();
  static MaterialColor pink = ColorUtil(Colors.pinkAccent.value).toMaterial();

  static Color textGray = ColorUtils.gray.shade800;
  static Color textWhite = ColorUtils.white.withOpacity(0.7);

  static MaterialColor bgColor = ColorUtil(0xffEEEEEE).toMaterial();

  static getBgColor() async {
    Color? value = await StorageUtils.bgColor();
    if (value is Color){
      return value;
    }
    return ColorUtils.black;
  }

}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}'
      '${alpha.toRadixString(16).padLeft(2, '0')}';
}
