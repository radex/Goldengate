import Foundation

// Arguments and results

extension Goldengate {
    public class Plugin {
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
            
            func add(name: String, _ method: Void -> Void) {
                routes[name] = { _ in
                    method()
                    return .None
                }
            }

            func add(name: String, _ method: Arguments -> Void) {
                routes[name] = { args in
                    method(args)
                    return .None
                }
            }

            func add(name: String, _ method: Void -> AnyObject?) {
                routes[name] = { _ in
                    return .Value(method())
                }
            }

            func add(name: String, _ method: Arguments -> AnyObject?) {
                routes[name] = { args in
                    return .Value(method(args))
                }
            }

            func add(name: String, _ method: Void -> Promise) {
                routes[name] = { _ in
                    return .Promise(method())
                }
            }

            func add(name: String, _ method: Arguments -> Promise) {
                routes[name] = { args in
                    return .Promise(method(args))
                }
            }
        }
        
        public func drawRoutes(routes: Router) {
            fatalError("Plugins must override drawRoutes method!")
        }
    }
}