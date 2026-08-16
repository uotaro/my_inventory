final RegExp _digitsOnlyPattern = RegExp(r'^\d+$');

/// GTIN形式のバーコード（EAN-8/UPC-A/EAN-13/GTIN-14）に付与されたチェックデジットを検証する。
/// 数字以外を含む・該当する桁数（8,12,13,14）でない場合は検証対象外としてtrueを返す
/// （QRコードなど別形式のバーコードを誤って弾かないため）。
bool isValidGtinChecksum(String code) {
  if (!_digitsOnlyPattern.hasMatch(code)) return true;
  if (!{8, 12, 13, 14}.contains(code.length)) return true;

  final digits = code.split('').map(int.parse).toList();
  final checkDigit = digits.removeLast();

  var sum = 0;
  for (var i = 0; i < digits.length; i++) {
    // チェックデジットに近い側(右端)から数えて奇数番目は×3、偶数番目は×1。
    final positionFromRight = digits.length - i;
    sum += digits[i] * (positionFromRight.isOdd ? 3 : 1);
  }

  final expectedCheckDigit = (10 - (sum % 10)) % 10;
  return expectedCheckDigit == checkDigit;
}
