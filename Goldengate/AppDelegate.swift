import Cocoa

// There are some bugs with SourceKit and weird shit happens in this file, so I'm putting the playground code in a separate file

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        play()
    }
}

func scheduleTermination() {
    NSTimer.scheduledTimerWithTimeInterval(0.5, target: NSApplication.sharedApplication(), selector: "terminate:", userInfo: nil, repeats: false)
}