import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let goldengate = Goldengate()
        goldengate.registerPlugins(["Foo": FooPlugin.self, "ReadLater": ReadLaterPlugin.self])
        goldengate.run("ReadLater", "async")
        NSApplication.sharedApplication().terminate(self)
    }

}

