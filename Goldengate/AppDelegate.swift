import Cocoa
import WebKit

// There are some bugs with SourceKit and weird shit happens in this file, so I'm putting the playground code in a separate file

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var contentView: NSView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let goldengate = Goldengate()
        let webView = goldengate.vc.webView
        
        webView.frame = contentView.bounds
        webView.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
        contentView.addSubview(webView)
        
        goldengate.vc.loadURL("http://goldengate.dev")
        
        play()
    }
}

class GoldengateMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let message = message.body as NSDictionary
        let plugin = message["plugin"] as String
        let method = message["method"] as String
        let args = transformArguments(message["arguments"] as [AnyObject])
        println(plugin)
        println(method)
        println(args)
    }
    
    func transformArguments(args: [AnyObject]) -> [AnyObject?] {
        return args.map { arg in
            if arg is NSNull {
                return nil
            } else {
                return arg
            }
        }
    }
}

