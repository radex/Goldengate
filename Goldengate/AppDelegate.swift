import Cocoa
import WebKit

// There are some bugs with SourceKit and weird shit happens in this file, so I'm putting the playground code in a separate file

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var contentView: NSView!
    var webView: WKWebView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let config = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.enableInspector()
        config.preferences = preferences
        
        let userContentController = WKUserContentController()
        userContentController.addScriptMessageHandler(GoldengateMessageHandler(), name: "goldengate")
        config.userContentController = userContentController
        
        webView = WKWebView(frame: contentView.bounds, configuration: config)
        webView.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
        contentView.addSubview(webView)
        
        let request = NSURLRequest(URL: NSURL(string: "http://goldengate.dev")!)
        webView.loadRequest(request)
        
        play()
    }
}

class GoldengateMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let message = message.body as NSDictionary
        println(message)
    }
}