#import <Cordova/CDVPlugin.h>

@interface LiveActivity : CDVPlugin
- (void) start:(CDVInvokedUrlCommand*)command;
- (void) getStartToken:(CDVInvokedUrlCommand*)command;
@end
