import Cocoa
import WebKit
import Taylor

// There are some bugs with SourceKit and weird shit happens in this file, so I'm putting the playground code in a separate file

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var contentView: NSView!
    
    let taylor = Taylor.Server()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // set up Taylor
        
        taylor.addHandler(Middleware.staticDirectory("", directory: "/Users/radex/Desktop/prodmag"))
        
        let port = 3001
        taylor.startListening(port: port, forever: false) { result in
            switch result {
            case .Success:
                println("Up and running!")
            case .Error(let e):
                println("Server start failed \(e)")
            }
        }
        
        // set up Goldengate
        let goldengate = Goldengate()
        goldengate.addPlugins(ReadLaterPlugin(), OtherPlugin())
        
        let webView = goldengate.vc.webView
        
        webView.frame = contentView.bounds
        webView.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
        contentView.addSubview(webView)
        
        goldengate.vc.loadURL("http://localhost:3001")
    }
}