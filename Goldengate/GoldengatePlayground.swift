import Foundation

func play() {
    let goldengate = Goldengate()
    goldengate <- ("Foo", FooPlugin.self)
    goldengate <- ("ReadLater", ReadLaterPlugin.self)
    
    // No arguments, no return value
    
    goldengate.run("ReadLater", "makeSomethingHappen", [])
    
    // Passing arguments
    
    goldengate.run("ReadLater", "saveUrl", ["http://foo.bar", "Lorem ipsum"])
    
    // Return value
    
    println(goldengate.run("ReadLater", "savedUrls", []))
    
    // Asynchronous call (resolved)
    
    catchPromiseValue(goldengate.run("ReadLater", "fetchSomething", [])!)
    
    // Asynchronous call (rejected)
    
    catchPromiseValue(goldengate.run("ReadLater", "asyncError", [])!)
}

func catchPromiseValue(result: Goldengate.Plugin.Result) {
    switch result {
    case .Promise(let promise):
        promise.onResolved = { value in
            println("Promise has resolved with value: \(value)")
        }
        promise.onRejected = { reason in
            println("Promise was rejected with reason: \(reason)")
        }
    default:
        println("Result is not a promise ಠ_ಠ")
    }
}