#import "SEGFirebaseIntegration.h"
#import <Analytics/SEGAnalyticsUtils.h>

#import <Firebase/Firebase.h>


@implementation SEGFirebaseIntegration

#pragma mark - Initialization

- (id)initWithSettings:(NSDictionary *)settings
{
    if (self = [super init]) {
        self.settings = settings;
        NSString *deepLinkURLScheme = [self.settings objectForKey:@"deepLinkURLScheme"];
        if (deepLinkURLScheme) {
            [FIROptions defaultOptions].deepLinkURLScheme = deepLinkURLScheme;
            SEGLog(@"[FIROptions defaultOptions].deepLinkURLScheme = %@;", deepLinkURLScheme);
        }
        
        [FIRApp configure];
        SEGLog(@"[FIRApp Configure]");
    }
    return self;
}

- (void)identify:(SEGIdentifyPayload *)payload
{
    if (payload.userId) {
        [FIRAnalytics setUserID:payload.userId];
        SEGLog(@"[FIRAnalytics setUserId:%@]", payload.userId);
    }
    
    [payload.traits enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        NSString *trait = [key stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *value = [obj stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [FIRAnalytics setUserPropertyString:value forName:trait];
        SEGLog(@"[FIRAnalytics setUserPropertyString:%@ forName:%@]", value, trait);
    }];
}

- (void)track:(SEGTrackPayload *)payload
 {
    
     NSString *name = [self firebaseEventNames:payload.event];
     NSDictionary *parameters = [self firebaseParameters:payload.properties];

     [FIRAnalytics logEventWithName:name parameters:parameters];
     SEGLog(@"[FIRAnalytics logEventWithName:%@ parameters:%@]", name, parameters);
 }


# pragma mark - Utilities
//Event names can be up to 32 characters long, may only contain alphanumeric
// characters and underscores ("_"), and must start with an alphabetic character. The "firebase_"
// prefix is reserved and should not be used.

- (NSString *)firebaseEventNames:(NSString *)event
{
    // Map the event names to special firebase events
    NSDictionary *mapper = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"add_payment_info", @"payment info entered",
                            @"add_to_cart", @"product added",
                            @"add_to_wishlist", @"product added to wishlist",
                            @"app_open", @"application opened",
                            @"begin_checkout", @"checkout started",
                            @"present_offer", @"promotion viewed",
                            @"search", @"products searched",
                            @"select_content", @"product clicked",
                            @"view_item", @"product viewed",
                            @"view_item_list", @"product list viewed",
                            @"share", @"product shared",
                            @"ecommerce_purchase", @"order completed",
                            @"purchase_refund", @"order refunded", nil
                            ];
    
    NSString *mappedEvent = [mapper objectForKey:[event lowercaseString]];
    
    if (mappedEvent) {
        return mappedEvent;
    } else {
        return [event stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    }
}

/// Params supply information that contextualize Events. You can associate up to 25 unique Params
/// with each Event type. Some Params are suggested below for certain common Events, but you are
/// not limited to these. You may supply extra Params for suggested Events or custom Params for
/// Custom events. Param names can be up to 24 characters long, may only contain alphanumeric
/// characters and underscores ("_"), and must start with an alphabetic character. Param values can
/// be up to 36 characters long. The "firebase_" prefix is reserved and should not be used.
- (NSDictionary *)firebaseParameters:(NSDictionary *)properties
{
    // Map to special firebase properties.
    NSDictionary *mapper = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"content_type", @"category",
                         // flatten location
                         @"destination", @"location",
                         @"start_date", @"checkin_date",
                         @"end_date", @"checkout_date",
                         @"item_category", @"category",
                         @"item_id", @"product_id",
                         @"item_name", @"name",
                         @"number_of_nights", @"booking_window",
                         @"number_of_rooms", @"quantity",
                         @"origin", @"origin",
                         @"price", @"price",
                         @"quantity", @"quantity",
                         @"search_term", @"query",
                         @"shipping", @"shipping",
                         @"tax", @"tax",
                         @"travel_class", @"class",
                         @"value", @"total",
                         @"value", @"revenue",
                         @"transaction_id", @"order_id", nil];
    
    return [SEGFirebaseIntegration map:properties withMap:mapper];
}

+ (NSDictionary *)map:(NSDictionary *)dictionary withMap:(NSDictionary *)map
{
    NSMutableDictionary *mapped = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    
    [map enumerateKeysAndObjectsUsingBlock:^(NSString *original, NSString *new, BOOL *stop) {
        id data = [mapped objectForKey:original];
        if (data) {
            // Check if the property could be a number, convert if so
            if ([data isKindOfClass:[NSString class]]) {
                NSNumber *number;
                BOOL validNumber;
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                number = [formatter numberFromString:data];
                validNumber = number != nil;
                
                if (validNumber) {
                    data = number;
                } else {
                    data = [data stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                }
            }
            
            [mapped setObject:data forKey:new];
            [mapped removeObjectForKey:original];
        }
    }];
    
    return [mapped copy];
}

@end