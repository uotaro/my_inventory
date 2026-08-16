import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()

    // システムの言語設定が日本語の場合はタイトルバーを「my在庫」に切り替える。
    let preferredLanguage = Locale.preferredLanguages.first ?? ""
    self.title = preferredLanguage.hasPrefix("ja") ? "my在庫" : "my_inventory"
  }
}
