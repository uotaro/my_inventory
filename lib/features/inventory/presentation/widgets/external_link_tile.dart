import 'package:flutter/material.dart';
import 'package:my_inventory/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// 外部リンクを開くためのListTile。
/// マスタ管理画面・アプリ情報画面のプライバシーポリシーリンクなどで共通利用する。
class ExternalLinkTile extends StatelessWidget {
  const ExternalLinkTile({
    super.key,
    required this.leading,
    required this.title,
    required this.url,
  });

  final IconData leading;
  final String title;
  final String url;

  Future<void> _open(BuildContext context) async {
    final l10n = L10n.of(context);
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.failedToOpenLink)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading),
      title: Text(title),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () => _open(context),
    );
  }
}
