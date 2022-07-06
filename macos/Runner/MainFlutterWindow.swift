import Cocoa
import FlutterMacOS
import bitsdojo_window_macos

class MainFlutterWindow: BitsdojoWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }

  override func bitsdojo_window_configure() -> UInt {
    // If you don't want to use a custom frame and prefer the standard window titlebar and buttons, you can remove the BDW_CUSTOM_FRAME flag from the code above.
    // If you don't want to hide the window on startup, you can remove the BDW_HIDE_ON_STARTUP flag from the code above.
    return BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP
  }
}
