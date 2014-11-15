import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let goldengate = Goldengate()
        goldengate <- ("Foo", FooPlugin.self)
        goldengate <- ("ReadLater", ReadLaterPlugin.self)
        goldengate.run("ReadLater", "noArgs")
        goldengate.run("ReadLater", "async")
        NSApplication.sharedApplication().terminate(self)
    }

}

