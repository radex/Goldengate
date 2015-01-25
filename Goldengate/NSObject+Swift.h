#import <Foundation/Foundation.h>

@interface NSObject (Swift)

- (void)swift_performSelectorNoReturn:(SEL)selector withObject:(id)object;
- (id)swift_performSelector:(SEL)selector withObject:(id)object;

@end