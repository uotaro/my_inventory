import 'package:flutter/material.dart';

/// 画面遷移を監視し、子画面から戻ってきたこと（didPopNext）を
/// 遷移元の画面へ通知するためのObserver。
/// MaterialAppのnavigatorObserversに登録して使う。
final routeObserver = RouteObserver<ModalRoute<void>>();
