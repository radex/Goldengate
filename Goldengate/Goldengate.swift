public class Goldengate {
    // MARK: Routing
    
    var plugins: [String: Plugin] = [:]
    
    func run(plugin: String, _ method: String, _ arguments: Plugin.Arguments) -> Plugin.Result? {
        if let result = plugins[plugin]?.routes[method]?.run(arguments) {
            return result
        } else {
            return nil
        }
    }
    
    func addPlugin(name: String, _ plugin: Plugin) {
        plugins[name] = plugin
    }
    
    func addPlugin(plugin: Plugin) {
        // get class name (ignore module name)
        let classNameComponents = plugin.className.componentsSeparatedByString(".")
        var name: NSString = classNameComponents[1]
        
        // remove "Plugin"
        if name.hasSuffix("Plugin") {
            name = name.substringToIndex(name.length - 6)
        }
        
        // add
        addPlugin(name as String, plugin)
    }
    
    func addPlugins(plugins: Plugin...) {
        for p in plugins {
            addPlugin(p)
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
        return NSString(data: data, encoding: NSUTF8StringEncoding)! as String
    }
}