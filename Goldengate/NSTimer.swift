import Foundation

typealias Block = () -> ()

class NSTimerActor {
    var block: Block
    
    init(block: Block) {
        self.block = block
    }
    
    dynamic func fire() {
        block()
    }
}

// FIXME: `make` class functions are a workaround for a crasher when using convenience initializers with Swift 1.1

extension NSTimer {
    class func make(intervalFromNow: NSTimeInterval, block: Block) -> NSTimer {
        let actor = NSTimerActor(block: block)
        return self.init(timeInterval: intervalFromNow, target: actor, selector: "fire", userInfo: nil, repeats: false)
    }
    
    class func make(every interval: NSTimeInterval, block: Block) -> NSTimer {
        let actor = NSTimerActor(block: block)
        return self.init(timeInterval: interval, target: actor, selector: "fire", userInfo: nil, repeats: true)
    }
    
    class func schedule(intervalFromNow: NSTimeInterval, block: Block) -> NSTimer {
        let timer = NSTimer.make(intervalFromNow, block)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        return timer
    }
    
    class func schedule(every interval: NSTimeInterval, block: Block) -> NSTimer {
        let timer = NSTimer.make(every: interval, block)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        return timer
    }
}