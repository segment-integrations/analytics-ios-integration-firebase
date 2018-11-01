#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegrationFactory.h>
#import <Firebase/Firebase.h>

@interface SEGFirebaseIntegrationFactory : NSObject <SEGIntegrationFactory>

@property (nonatomic, strong) FIROptions *options;

+ (instancetype)instance;

+ (instancetype)instance:(FIROptions *)options;

@end
