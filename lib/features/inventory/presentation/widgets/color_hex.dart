import 'package:flutter/material.dart';

/// '#RRGGBB' または 'RRGGBB' 形式の文字列を Color に変換する。
/// 形式が不正な場合は null を返す。
Color? parseHexColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  var value = hex.replaceAll('#', '');
  if (value.length == 6) value = 'FF$value';
  if (value.length != 8) return null;
  final intValue = int.tryParse(value, radix: 16);
  return intValue == null ? null : Color(intValue);
}

/// Color を '#RRGGBB' 形式の文字列に変換する（アルファ値は含めない）。
String colorToHex(Color color) {
  final rgb = color.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
