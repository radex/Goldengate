public class Goldengate {
    // MARK: Routing
    
    private var routes: [String: [String: Plugin.Route]] = [:]
    
    func run(plugin: String, _ method: String, _ arguments: Plugin.Arguments) -> Plugin.Result? {
        if let result = routes[plugin]?[method]?(arguments) {
            return result
        } else {
            return nil
        }
    }
    
    // MARK: Web view
    
    private(set) var vc: ViewController!
    
    // MARK: Initialization
    
    init() {
         vc = ViewController(bridge: self)
    }
    
    // MARK: Helpers
    
    class func toJSON(json: AnyObject!) -> String {
        let data = NSJSONSerialization.dataWithJSONObject(json, options: nil, error: nil)!
        return NSString(data: data, encoding: NSUTF8StringEncoding)!
    }
}

// Plugin routing operator

func <- (bridge: Goldengate, args: (String, Goldengate.Plugin)) {
    let router = Goldengate.Plugin.Router()
    args.1.drawRoutes(router)
    bridge.routes[args.0] = router.routes
}