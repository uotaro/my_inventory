import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_log.freezed.dart';

@freezed
abstract class StockLog with _$StockLog {
  const factory StockLog({
    required int id,
    required int itemId,
    required double changeAmount,
    String? reason,
    required DateTime createdAt,
  }) = _StockLog;
}
