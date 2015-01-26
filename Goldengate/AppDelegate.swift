import Cocoa
import WebKit

// There are some bugs with SourceKit and weird shit happens in this file, so I'm putting the playground code in a separate file

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var contentView: NSView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let goldengate = Goldengate()
        goldengate.addPlugins(ReadLaterPlugin(), OtherPlugin())
        
        let webView = goldengate.vc.webView
        
        webView.frame = contentView.bounds
        webView.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
        contentView.addSubview(webView)
        
        goldengate.vc.loadURL("http://goldengate.dev")
    }
}