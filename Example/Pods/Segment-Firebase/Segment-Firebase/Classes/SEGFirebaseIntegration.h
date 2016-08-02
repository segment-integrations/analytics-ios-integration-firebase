//
//  SEGFirebaseIntegration.h
//  Pods
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>


@interface SEGFirebaseIntegration : NSObject <SEGIntegration>

@property (nonatomic, strong) NSDictionary *settings;

- (id)initWithSettings:(NSDictionary *)settings;

@end
