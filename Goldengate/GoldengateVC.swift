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
            let callbackID = message["callbackID"] as Int
            
            println("Received message #\(callbackID) to dispatch \(plugin).\(method)(\(args))")
            
            run(plugin, method, args, callbackID: callbackID)
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
        
        func run(plugin: String, _ method: String, _ args: [AnyObject!], callbackID: Int) {
            if let result = bridge.run(plugin, method, args) {
                println(result)
                
                switch result {
                case .None: break
                case .Value(let value):
                    callBack(callbackID, success: true, reasonOrValue: value)
                case .Promise(let promise):
                    promise.onResolved = { value in
                        self.callBack(callbackID, success: true, reasonOrValue: value)
                        println("Promise has resolved with value: \(value)")
                    }
                    promise.onRejected = { reason in
                        self.callBack(callbackID, success: false, reasonOrValue: reason)
                        println("Promise was rejected with reason: \(reason)")
                    }
                }
            } else {
                println("Error: No such plugin or method")
            }
        }
        
        private func callBack(callbackID: Int, success: Bool, reasonOrValue: AnyObject!) {
            // we're wrapping reason/value in array, because NSJSONSerialization won't serialize scalar values. to be fixed.
            bridge.vc.webView.evaluateJavaScript("Goldengate.callBack(\(callbackID), \(success), \(Goldengate.toJSON([reasonOrValue])))", completionHandler: nil)
        }
    }
}