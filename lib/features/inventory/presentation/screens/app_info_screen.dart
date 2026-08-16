import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_inventory/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/external_links_config.dart';
import '../providers/app_info_providers.dart';
import '../widgets/external_link_tile.dart';

/// アプリ情報画面。
/// アイコン・バージョン、プライバシーポリシーへのリンク、
/// 商品検索でYahoo!ショッピング商品検索API(v3)を利用していることの
/// 表示（利用規約で必須の「Web Services by Yahoo! JAPAN」表記）を行う。
class AppInfoScreen extends ConsumerWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final packageInfoAsync = ref.watch(appPackageInfoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appInfoTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/icon/icon_full_square.png',
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    packageInfoAsync.when(
                      data: (info) => l10n.appVersionWithBuild(
                        info.version,
                        info.buildNumber,
                      ),
                      loading: () => '',
                      error: (error, stack) => '',
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
                ExternalLinkTile(
                  leading: Icons.privacy_tip_outlined,
                  title: l10n.privacyPolicyLabel,
                  url: privacyPolicyUrl,
                ),
                const Divider(height: 1),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: _YahooAttributionLink(label: l10n.yahooAttributionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

/// 商品検索API(v3)の利用規約で必須の表記。目立たないよう小さく淡色で表示する。
class _YahooAttributionLink extends StatelessWidget {
  const _YahooAttributionLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(
        Uri.parse(yahooDeveloperNetworkUrl),
        mode: LaunchMode.externalApplication,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey,
        ),
      ),
    );
  }
}
