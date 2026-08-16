import 'package:flutter/material.dart';
import 'package:my_inventory/l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/utils/barcode_checksum.dart';

/// バーコードスキャン画面を開き、読み取った値（rawValue）を返す。
/// ユーザーがキャンセルした場合は null を返す。
Future<String?> scanBarcode(BuildContext context) {
  return Navigator.push<String>(
    context,
    MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
  );
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  /// カメラのピント調整中などによる一瞬の誤読み取りを弾くため、
  /// 同じ値を連続でこの回数検出できて初めて確定とみなす。
  static const _requiredConsecutiveMatches = 2;

  bool _handled = false;
  String? _pendingCode;
  int _consecutiveMatches = 0;

  void _onDetect(BarcodeCapture capture) {
    if (_handled || capture.barcodes.isEmpty) return;
    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    // JAN/EANなどチェックデジットを持つ形式では、検証に失敗した時点で
    // 誤読み取りとみなし連続カウントをリセットする。
    if (!isValidGtinChecksum(code)) {
      if (_pendingCode != null) setState(_resetPending);
      return;
    }

    if (code == _pendingCode) {
      _consecutiveMatches++;
    } else {
      _pendingCode = code;
      _consecutiveMatches = 1;
    }

    if (_consecutiveMatches < _requiredConsecutiveMatches) {
      setState(() {});
      return;
    }

    _handled = true;
    Navigator.pop(context, code);
  }

  void _resetPending() {
    _pendingCode = null;
    _consecutiveMatches = 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final isConfirming =
        _pendingCode != null && _consecutiveMatches < _requiredConsecutiveMatches;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanBarcodeTitle)),
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          if (isConfirming)
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.scanConfirmingLabel,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
