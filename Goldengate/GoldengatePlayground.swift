import Foundation

func play() {
    let goldengate = Goldengate()
    goldengate <- ("Foo", FooPlugin.self)
    goldengate <- ("ReadLater", ReadLaterPlugin.self)
    
    println(goldengate.run("ReadLater", "noArgs", []))
    
    switch goldengate.run("ReadLater", "async", [])! {
    case .Promise(let promise):
        promise.onResolved = { value in
            println("Promise has resolved with value: \(value)")
        }
        promise.onRejected = { reason in
            println("Promise was rejected with reason: \(reason)")
        }
    default: break
    }
    
    scheduleTermination()
}