extension Goldengate {
    public class ViewController: NSViewController {
        private var bridge: Goldengate
        
        init!(bridge: Goldengate) {
            self.bridge = bridge
            super.init(nibName: nil, bundle: nil)
        }
        
        required public init?(coder: NSCoder) {
            fatalError("Not implementing NSCoding ಠ_ಠ")
        }
        
        // MARK: Web view
        
        public var webView: WKWebView! {
            return view as WKWebView
        }
        
        public var configuration = WKWebViewConfiguration()
        
        public override func loadView() {
            // configure
            let preferences = WKPreferences()
            preferences.enableInspector()
            configuration.preferences = preferences
            
            let userContentController = WKUserContentController()
            userContentController.addScriptMessageHandler(MessageHandler(bridge: bridge), name: "goldengate")
            configuration.userContentController = userContentController
            
            // set up view
            view = WKWebView(frame: .zeroRect, configuration: configuration)
        }
        
        // MARK: Load requests
        
        public func loadURL(url: String) {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        }
    }
}

extension Goldengate {
    class MessageHandler: NSObject, WKScriptMessageHandler {
        var bridge: Goldengate
        
        init(bridge: Goldengate) {
            self.bridge = bridge
            super.init()
        }
        
        // MARK: Receiving messages
        
        func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
            let message = message.body as NSDictionary
            let plugin = message["plugin"] as String
            let method = message["method"] as String
            let args = transformArguments(message["arguments"] as [AnyObject])
            
            println("Received message to dispatch \(plugin).\(method)(\(args))")
            
            runAndPrintResult(plugin, method, args)
        }
        
        func transformArguments(args: [AnyObject]) -> [AnyObject!] {
            return args.map { arg in
                if arg is NSNull {
                    return nil
                } else {
                    return arg
                }
            }
        }
        
        func runAndPrintResult(plugin: String, _ method: String, _ args: [AnyObject!]) {
            if let result = bridge.run(plugin, method, args) {
                println(result)
                
                if let promise = result.promise {
                    catchPromisedResult(promise)
                }
            } else {
                println("Error: No such plugin or method")
            }
        }
        
        func catchPromisedResult(promise: Plugin.Promise) {
            promise.onResolved = { value in
                println("Promise has resolved with value: \(value)")
            }
            promise.onRejected = { reason in
                println("Promise was rejected with reason: \(reason)")
            }
        }
    }
}