extension Goldengate {
    public class ViewController: NSViewController {
        var bridge: Goldengate
        
        init(bridge: Goldengate) {
            self.bridge = bridge
            super.init()
        }
        
        required public init?(coder: NSCoder) {
            fatalError("Not implementing NSCoding ಠ_ಠ")
        }
        
        // MARK: Web view
        
        public var webView: WKWebView! {
            return view as WKWebView
        }
        
        public lazy var configuration: WKWebViewConfiguration = {
            let config = WKWebViewConfiguration()
            let preferences = WKPreferences()
            preferences.enableInspector()
            config.preferences = preferences
            
            let userContentController = WKUserContentController()
            userContentController.addScriptMessageHandler(GoldengateMessageHandler(), name: "goldengate")
            config.userContentController = userContentController
            
            return config
        }()
        
        public override func loadView() {
            view = WKWebView(frame: .zeroRect, configuration: configuration)
        }
        
        // MARK: Load requests
        
        public func loadURL(url: String) {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        }
    }
}