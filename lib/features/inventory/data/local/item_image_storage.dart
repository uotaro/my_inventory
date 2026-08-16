import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// item_images ディレクトリの絶対パス。
/// iOSシミュレータ等ではアプリを再インストールするたびにアプリコンテナの
/// ディレクトリが変わるため、起動時（[warmUpItemImagesDirectory]）に一度だけ
/// 解決してキャッシュし、以降は同期的に参照する。
String? _cachedImagesDirPath;

/// アプリ起動時に一度だけ呼び出し、item_images ディレクトリを解決して
/// キャッシュしておく。初回フレーム表示を遅らせないよう runApp を待たせずに
/// 並行実行される想定のため、[resolveItemImageFile] はキャッシュ未完了時の
/// フォールバックを持つ。
Future<void> warmUpItemImagesDirectory() async {
  final dir = await _ensureImagesDirectory();
  _cachedImagesDirPath = dir.path;
}

Future<Directory> _ensureImagesDirectory() async {
  final appDir = await getApplicationDocumentsDirectory();
  final imagesDir = Directory('${appDir.path}/item_images');
  if (!await imagesDir.exists()) {
    await imagesDir.create(recursive: true);
  }
  return imagesDir;
}

/// image_picker が返す一時ファイルはOSに消される可能性があるため、
/// items.image_path に保存するパスは必ずこの関数でアプリの永続ディレクトリに
/// コピーしたものを使う。
///
/// 戻り値はファイル名のみ（絶対パスではない）。アプリコンテナの絶対パスを
/// そのまま保存すると、再インストール等でコンテナのディレクトリが変わった際に
/// 参照が壊れるため、表示時には [resolveItemImageFile] で現在のディレクトリと
/// 組み合わせて解決する。
Future<String> saveItemImage(String sourcePath) async {
  final imagesDir = await _ensureImagesDirectory();

  final extension = sourcePath.contains('.')
      ? sourcePath.split('.').last
      : 'jpg';
  final fileName = '${DateTime.now().microsecondsSinceEpoch}.$extension';
  await File(sourcePath).copy('${imagesDir.path}/$fileName');
  return fileName;
}

/// DBに保存された画像パス（新形式のファイル名、または旧バージョンで保存された
/// 絶対パス）から、現在のアプリの item_images ディレクトリ上のファイルを解決する。
/// [warmUpItemImagesDirectory] が起動時に完了している前提。
File resolveItemImageFile(String storedValue) {
  final dirPath = _cachedImagesDirPath;
  if (dirPath == null) return File(storedValue);
  return File('$dirPath/${_basename(storedValue)}');
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final index = normalized.lastIndexOf('/');
  return index == -1 ? normalized : normalized.substring(index + 1);
}

/// アイテムの削除・画像差し替え時に、不要になった画像ファイルを削除する。
/// ファイルが既に存在しない場合や削除に失敗した場合は無視する
/// （画像の後始末に失敗してもアイテムの削除・更新自体は成立させたいため）。
Future<void> deleteItemImageIfExists(String? storedValue) async {
  if (storedValue == null) return;
  try {
    final file = resolveItemImageFile(storedValue);
    if (await file.exists()) {
      await file.delete();
    }
  } catch (_) {
    // 画像削除の失敗はアイテム操作を妨げない。
  }
}
