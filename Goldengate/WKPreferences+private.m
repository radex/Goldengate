#import "WKPreferences+private.h"

@implementation WKPreferences (Private)

- (void) enableInspector {
    [self performSelector:@selector(_setDeveloperExtrasEnabled:) withObject:@YES];
}

@end
