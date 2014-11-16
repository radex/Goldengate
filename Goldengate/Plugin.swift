import Foundation

// Arguments and results

extension Goldengate {
    public class Plugin {
        private init() { }
        
        // MARK: Input / output
        
        public typealias Arguments = [AnyObject!]
        
        enum Result: Printable {
            case None
            case Value(AnyObject?)
            case Promise(Plugin.Promise)
            
            var description: String {
                switch self {
                case .None: return "No result"
                case .Value(let value): return "Value: \(value)"
                case .Promise(_): return "Promise of a future value"
                }
            }
            
            var promise: Plugin.Promise? {
                switch self {
                case .Promise(let promise): return promise
                default: return nil
                }
            }
        }
        
        // MARK: Promises
        
        public class Promise {
            private init() {}
            
            enum State {
                case Pending
                case Resolved(AnyObject!)
                case Rejected(AnyObject!)
            }
            
            private(set) var state: State = .Pending
            var onResolved: (AnyObject! -> Void)?
            var onRejected: (AnyObject! -> Void)?
        }
        
        public class Deferred {
            private(set) var promise = Promise()
            
            public func resolve(value: AnyObject!) {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    switch self.promise.state {
                    case .Pending:
                        println("Resolving a promise")
                        self.promise.state = .Resolved(value)
                        self.promise.onResolved?(value)
                    default:
                        println("Can't resolve; promise already fulfilled!")
                    }
                }
            }
            
            public func reject(reason: AnyObject!) {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    switch self.promise.state {
                    case .Pending:
                        println("Rejecting a promise")
                        self.promise.state = .Rejected(reason)
                        self.promise.onRejected?(reason)
                    default:
                        println("Can't reject; promise already fulfilled!")
                    }
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