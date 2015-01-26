public class Goldengate {
    // MARK: Routing
    
    var plugins: [String: Plugin] = [:]
    
    func run(plugin: String, _ method: String, _ arguments: Plugin.Arguments) -> Plugin.Result? {
        if let result = plugins[plugin]?.routes[method]?(arguments) {
            return result
        } else {
            return nil
        }
    }
    
    func addPlugin(name: String, _ plugin: Plugin) {
        plugins[name] = plugin
    }
    
    func addPlugin(plugin: Plugin) {
        
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