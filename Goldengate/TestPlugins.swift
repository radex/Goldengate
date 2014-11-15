final class FooPlugin: Goldengate.Plugin {
    override class func drawRoutes(routes: Router) {
    }
}

final class ReadLaterPlugin: Goldengate.Plugin {
    override class func drawRoutes(routes: Router) {
        routes <- ("noArgs", noArgs)
        routes <- ("someArgs", someArgs)
        routes <- ("someResult", someResult)
        routes <- ("async", async)
    }
    
    class func noArgs() {
        
    }
    
    class func someArgs(args: Arguments) {
        
    }
    
    class func someResult() -> AnyObject {
        return ["foo": "bar", "baz": 2]
    }
    
    class func async() -> Promise {
        let d = Deferred()
        d.resolve("foo")
        d.reject("Error in this and that")
        return d.promise
    }
}