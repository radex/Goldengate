import Foundation

// Arguments and results

extension Goldengate {
    public class Plugin: NSObject {
        override init() {
            super.init()
            drawRoutes()
        }
        
        // MARK: Input / output
        
        public typealias Arguments = NSArray
        
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
        
        @objc public class Promise {
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
        
        // MARK: Actions
        
        class Action {
            let plugin: Plugin
            let selector: Selector
            let hasArgs: Bool
            let returns: Bool
            
            init(plugin: Plugin, details: (selector: Selector, hasArgs: Bool, returns: Bool)) {
                self.plugin   = plugin
                self.selector = details.selector
                self.hasArgs  = details.hasArgs
                self.returns  = details.returns
            }
            
            func run(args: Arguments) -> Result {
                let args: NSArray? = (hasArgs ? args : nil)
                
                if returns {
                    let returnValue: AnyObject! = plugin.swift_performSelector(selector, withObject: args)
                    
                    if let promise = returnValue as? Promise {
                        return .Promise(promise)
                    } else {
                        return .Value(returnValue)
                    }
                } else {
                    plugin.swift_performSelectorNoReturn(selector, withObject: args)
                    return .None
                }
            }
        }
        
        // MARK: Routing
        
        var routes: [String: Action] = [:]
        
        public func drawRoutes() {
            for details in getMethods().map(methodDetails).filter({$0.selector != "init"}) {
                let name = nameForSelector(details.selector)
                routes[name] = Action(plugin: self, details: details)
            }
        }
        
        private func nameForSelector(selector: Selector) -> String {
            let string: NSString = selector.description
            if string.hasSuffix(":") {
               return string.substringToIndex(string.length - 1)
            } else {
                return string as String
            }
        }
        
        private func methodDetails(method: Method) -> (selector: Selector, hasArgs: Bool, returns: Bool) {
            // TODO: refactor to warn about invalid methods
            let selector = method_getName(method)
            let takesArguments = (method_getNumberOfArguments(method) == 3)
            let returnTypeEncoding = String(CString: method_copyReturnType(method), encoding: NSUTF8StringEncoding)!
            let returnsObject = (returnTypeEncoding == "@")
            return (selector, takesArguments, returnsObject)
        }
        
        func getMethods() -> [Method] {
            var count: UInt32 = 0
            let methodsPtr = class_copyMethodList(self.dynamicType, &count)
            var methods: [Method] = []
            
            for i in (0..<count) {
                methods.append(methodsPtr[Int(i)])
            }
            
            free(methodsPtr)
            return methods
        }
    }
}