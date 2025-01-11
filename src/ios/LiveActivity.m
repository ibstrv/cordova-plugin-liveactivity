#import "LiveActivity.h"
#import "CafeApp-Swift.h"

@implementation LiveActivity

- (void) startLiveActivity:(CDVInvokedUrlCommand*)command {
    NSDictionary *params = [command.arguments objectAtIndex:0];
    NSString *orderId = params[@"orderId"];
    NSString *orderNum = params[@"orderNum"];
    NSString *orderStatus = params[@"orderStatus"];
    NSNumber *orderState = params[@"orderState"];

    [LiveActivityManager startLiveActivityWithOrderId:orderId orderNum:orderNum orderStatus:orderStatus orderState:orderState];
}

- (void)start:(CDVInvokedUrlCommand*)command {
    if (command.arguments.count == 0 || ![command.arguments[0] isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Error: Invalid arguments. Expected a dictionary.");
        return;
    }

    NSDictionary *params = [command.arguments objectAtIndex:0];

    // Проверяем наличие ключей и их значения
    NSString *orderId = params[@"orderId"];
    NSString *orderNum = params[@"orderNum"];
    NSString *orderStatus = params[@"orderStatus"];
    NSNumber *orderState = params[@"orderState"];

    if (![orderId isKindOfClass:[NSString class]] || orderId.length == 0) {
        NSLog(@"Error: Missing or invalid 'orderId'");
        return;
    }
    
    if (![orderNum isKindOfClass:[NSString class]] || orderNum.length == 0) {
        NSLog(@"Error: Missing or invalid 'orderNum'");
        return;
    }

    if (![orderStatus isKindOfClass:[NSString class]] || orderStatus.length == 0) {
        NSLog(@"Error: Missing or invalid 'orderStatus'");
        return;
    }

    if (![orderState isKindOfClass:[NSNumber class]]) {
        NSLog(@"Error: Missing or invalid 'orderState'");
        return;
    }

    NSLog(@"Starting Live Activity with orderId: %@, status: %@, state: %@", orderId, orderStatus, orderState);
    [LiveActivityManager startLiveActivityWithOrderId:orderId
                                              orderNum:orderNum
                                           orderStatus:orderStatus
                                            orderState:orderState];
}

- (void) getStartToken:(CDVInvokedUrlCommand*)command {
    [LiveActivityManager observePushToStartToken];
}

@end
