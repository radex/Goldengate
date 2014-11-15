import Foundation

// Arguments and results

extension Goldengate {
    public class Plugin {
        private init() { }
        
        // MARK: Input / output
        
        public typealias Arguments = [AnyObject!]
        
        enum Result {
            case None
            case Value(AnyObject?)
            case Promise(Plugin.Promise)
        }
        
        // MARK: Promises
        
        public class Promise {
            private init() {}
            var onResolved: (AnyObject! -> Void)?
            var onRejected: (AnyObject! -> Void)?
        }
        
        public class Deferred {
            private(set) var promise = Promise()
            
            public func resolve(value: AnyObject!) {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.promise.onResolved?(value)
                    ()
                }
            }
            
            public func reject(reason: AnyObject!) {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.promise.onRejected?(reason)
                    ()
                }
            }
        }
        
        // MARK: Routing
        
        typealias Route = Arguments -> Result
        
        public class Router {
            var routes: [String: Route] = [:]
        }
        
        public class func drawRoutes(routes: Router) {
            fatalError("Plugins must override drawRoutes method!")
        }
    }
}

// Method routing operator

infix operator <- { associativity right precedence 90 }

func <- (router: Goldengate.Plugin.Router, args: (String, (Void -> Void))) {
    router.routes[args.0] = { _ in
        args.1()
        return .None
    }
}

func <- (router: Goldengate.Plugin.Router, args: (String, (Goldengate.Plugin.Arguments -> Void))) {
    router.routes[args.0] = { params in
        args.1(params)
        return .None
    }
}

func <- (router: Goldengate.Plugin.Router, args: (String, (Void -> AnyObject?))) {
    router.routes[args.0] = { _ in
        return .Value(args.1())
    }
}

func <- (router: Goldengate.Plugin.Router, args: (String, (Goldengate.Plugin.Arguments -> AnyObject?))) {
    router.routes[args.0] = { params in
        return .Value(args.1(params))
    }
}

func <- (router: Goldengate.Plugin.Router, args: (String, (Void -> Goldengate.Plugin.Promise))) {
    router.routes[args.0] = { _ in
        return .Promise(args.1())
    }
}

func <- (router: Goldengate.Plugin.Router, args: (String, (Goldengate.Plugin.Arguments -> Goldengate.Plugin.Promise))) {
    router.routes[args.0] = { params in
        return .Promise(args.1(params))
    }
}