import Foundation

final class FooPlugin: Goldengate.Plugin {
    override class func drawRoutes(routes: Router) {
    }
}

final class ReadLaterPlugin: Goldengate.Plugin {
    override class func drawRoutes(routes: Router) {
        routes <- ("makeSomethingHappen", makeSomethingHappen)
        routes <- ("saveUrl", saveUrl)
        routes <- ("savedUrls", savedUrls)
        routes <- ("fetchSomething", fetchSomething)
        routes <- ("asyncError", asyncError)
    }
    
    class func makeSomethingHappen() {
        println("Invoking some action that takes no arguments and returns no value")
    }
    
    class func saveUrl(args: Arguments) {
        let url = args[0] as String
        let description = args[1] as String
        
        println("Saving \(url) with description: \(description)")
    }
    
    class func savedUrls() -> AnyObject {
        return [["url": "marco.coffee", "description": "Coffee is stupid"], ["url": "example.com", "description": "Blah blah blah"]]
    }
    
    class func fetchSomething() -> Promise {
        let d = Deferred()

        NSTimer.schedule(0.1) {
            d.resolve("Fetched something!")
        }
        
        return d.promise
    }
    
    class func asyncError() -> Promise {
        let d = Deferred()
        
        NSTimer.schedule(0.15) {
            d.reject("Shit broke here and there")
            d.reject("This won't come thru")
        }
        
        return d.promise
    }
}