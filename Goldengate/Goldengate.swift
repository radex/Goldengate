public class Goldengate {
    private var routes: [String: [String: Plugin.Route]] = [:]
    
    public func registerPlugins(plugins: [String: Plugin.Type]) {
        for (name, plugin) in plugins {
            let router = Plugin.Router()
            plugin.drawRoutes(router)
            routes[name] = router.routes
        }
    }
    
    
    private func run(plugin: String, _ method: String, _ arguments: Plugin.Arguments) -> Plugin.Result? {
        if let result = routes[plugin]?[method]?(arguments) {
            return result
        } else {
            return nil
        }
    }
    
    public func run(plugin: String, _ method: String) {
        if let result = run(plugin, method, Plugin.Arguments()) {
            switch result {
            case .None: print("No result")
            case .Value(let value): print(value)
            case .Promise(let promise): print(promise)
            }
        } else {
            print("No such plugin or method")
        }
    }
}