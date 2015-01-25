@import ObjectiveC;
#import "NSObject+Swift.h"

@implementation NSObject (Swift)

// based on https://github.com/tokorom/performSelector-swift

- (id)swift_performSelector:(SEL)selector withObject:(id)object
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:selector withObject:object];
#pragma clang diagnostic pop
}

- (void)swift_performSelectorNoReturn:(SEL)selector withObject:(id)object
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector withObject:object];
#pragma clang diagnostic pop
}

@end