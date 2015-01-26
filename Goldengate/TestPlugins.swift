import Foundation

class ReadLaterPlugin: Goldengate.Plugin {
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

class OtherPlugin: Goldengate.Plugin {
    func someRandomAction() { }
}