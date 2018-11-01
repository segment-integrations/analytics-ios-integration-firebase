//
//  SEGFirebaseIntegrationFactory.m
//  Pods
//

#import "SEGFirebaseIntegrationFactory.h"
#import "SEGFirebaseIntegration.h"


@implementation SEGFirebaseIntegrationFactory

+ (instancetype)instance
{
    static dispatch_once_t once;
    static SEGFirebaseIntegrationFactory *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (instancetype)instance:(FIROptions *)options
{
    static dispatch_once_t once;
    static SEGFirebaseIntegrationFactory *sharedInstance;
    dispatch_once(&once, ^{
      sharedInstance = [[self alloc] init];
    });
    sharedInstance.options = options;
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    return self;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGFirebaseIntegration alloc] initWithSettings:settings andOptions: self.options];
}

- (NSString *)key
{
    return @"Firebase";
}

@end
