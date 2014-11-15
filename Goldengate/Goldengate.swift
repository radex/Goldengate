public class Goldengate {
    private var routes: [String: [String: Plugin.Route]] = [:]
    
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
            case .None: println("No result")
            case .Value(let value): println(value)
            case .Promise(let promise): println(promise)
            }
        } else {
            print("No such plugin or method")
        }
    }
}

// Plugin routing operator

func <- (bridge: Goldengate, args: (String, Goldengate.Plugin.Type)) {
    let router = Goldengate.Plugin.Router()
    args.1.drawRoutes(router)
    bridge.routes[args.0] = router.routes
}