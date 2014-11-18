import Foundation

class ReadLaterPlugin: Goldengate.Plugin {
    override func drawRoutes(routes: Router) {
        routes <- ("makeSomethingHappen", makeSomethingHappen)
        routes <- ("saveUrl", saveUrl)
        routes <- ("savedUrls", savedUrls)
        routes <- ("fetchSomething", fetchSomething)
        routes <- ("asyncError", asyncError)
    }
    
    func makeSomethingHappen() {
        println("Invoking some action that takes no arguments and returns no value")
    }
    
    func saveUrl(args: Arguments) {
        let url = args[0] as String
        let description = args[1] as String
        
        println("Saving \(url) with description: \(description)")
    }
    
    func savedUrls() -> AnyObject {
        return [["url": "marco.coffee", "description": "Coffee is stupid"], ["url": "example.com", "description": "Blah blah blah"]]
    }
    
    func fetchSomething() -> Promise {
        let d = Deferred()

        NSTimer.schedule(0.1) {
            d.resolve("Fetched something!")
        }
        
        return d.promise
    }
    
    func asyncError() -> Promise {
        let d = Deferred()
        
        NSTimer.schedule(0.15) {
            d.reject("Shit broke here and there")
            d.reject("This won't come thru")
        }
        
        return d.promise
    }
}