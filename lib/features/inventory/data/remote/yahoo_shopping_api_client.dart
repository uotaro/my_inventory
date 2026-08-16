import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/yahoo_shopping_api_config.dart';

/// Yahoo!ショッピング商品検索API(v3)を使い、JANコードから商品名を検索するクライアント。
/// https://developer.yahoo.co.jp/webapi/shopping/v3/itemsearch.html
///
/// APIの利用制限（1クエリ/秒、Client IDあたり1分間30リクエスト）を守るため、
/// 実際のリクエストはこのクラス内で直列化・間隔調整して送信する。
/// 連続スキャンなどで呼び出しが重なっても、ここで待ち合わせて順番に送信される。
class YahooShoppingApiClient {
  YahooShoppingApiClient({
    http.Client? httpClient,
    Duration minInterval = const Duration(milliseconds: 1100),
    int maxRequestsPerWindow = 30,
    Duration window = const Duration(seconds: 61),
    Duration maxWait = const Duration(seconds: 5),
  }) : _httpClient = httpClient ?? http.Client(),
       _minInterval = minInterval,
       _maxRequestsPerWindow = maxRequestsPerWindow,
       _window = window,
       _maxWait = maxWait;

  final http.Client _httpClient;

  /// 連続リクエストの最小間隔（1クエリ/秒制限を守るため）。
  final Duration _minInterval;

  /// [_window] あたりに許容する最大リクエスト数（1分間30リクエスト制限を守るため）。
  final int _maxRequestsPerWindow;
  final Duration _window;

  /// レート制限のために待つ必要がある時間がこれを超える場合は、
  /// APIを呼ばずに諦めて手入力へフォールバックする（UIを長時間ブロックしないため）。
  final Duration _maxWait;

  static final _endpoint = Uri.parse(
    'https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch',
  );

  DateTime? _lastRequestAt;
  final List<DateTime> _recentRequestTimes = [];

  /// 呼び出しを直列に繋いでいくキュー。常に正常完了として繋ぐことで、
  /// 1件の失敗が後続の待ち合わせを壊さないようにする。
  Future<void> _queue = Future.value();

  /// JANコードに一致する商品名を検索する。
  /// 通信エラー・タイムアウト・該当なし・レート制限による待機超過の場合は
  /// 全てnullを返す（呼び出し側は手入力にフォールバックする）。
  Future<String?> searchNameByJanCode(String janCode) {
    final result = _queue.then((_) => _throttledSearch(janCode));
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }

  Future<String?> _throttledSearch(String janCode) async {
    final canProceed = await _waitForRateLimit();
    if (!canProceed) return null;
    _recordRequest();

    final uri = _endpoint.replace(
      queryParameters: {
        'appid': yahooShoppingClientId,
        'jan_code': janCode,
        'results': '1',
      },
    );

    try {
      final response = await _httpClient
          .get(uri)
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;

      final decoded =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final hits = decoded['hits'] as List<dynamic>?;
      if (hits == null || hits.isEmpty) return null;

      final name = (hits.first as Map<String, dynamic>)['name'] as String?;
      return (name == null || name.trim().isEmpty) ? null : name.trim();
    } catch (_) {
      return null;
    }
  }

  /// レート制限を守るために必要な待機を行う。
  /// 待機時間が[_maxWait]を超える場合は待たずにfalseを返す（呼び出しを諦める）。
  Future<bool> _waitForRateLimit() async {
    final requiredWait = _requiredWait();
    if (requiredWait > _maxWait) return false;
    if (requiredWait > Duration.zero) {
      await Future.delayed(requiredWait);
    }
    return true;
  }

  /// 現時点でリクエストを送るために必要な待機時間（不要ならDuration.zero）。
  Duration _requiredWait() {
    final now = DateTime.now();
    _recentRequestTimes.removeWhere((t) => now.difference(t) >= _window);

    var wait = Duration.zero;

    final lastRequestAt = _lastRequestAt;
    if (lastRequestAt != null) {
      final elapsed = now.difference(lastRequestAt);
      if (elapsed < _minInterval) {
        wait = _minInterval - elapsed;
      }
    }

    if (_recentRequestTimes.length >= _maxRequestsPerWindow) {
      final untilWindowClears = _window - now.difference(_recentRequestTimes.first);
      if (untilWindowClears > wait) wait = untilWindowClears;
    }

    return wait;
  }

  void _recordRequest() {
    final now = DateTime.now();
    _lastRequestAt = now;
    _recentRequestTimes.add(now);
  }
}
