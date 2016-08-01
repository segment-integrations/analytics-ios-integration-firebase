//
//  Segment-FirebaseTests.m
//  Segment-FirebaseTests
//
//  Created by wcjohnson11 on 07/25/2016.
//  Copyright (c) 2016 wcjohnson11. All rights reserved.
//

// https://github.com/Specta/Specta

SpecBegin(InitialSpecs)

describe(@"SEGFirebaseIntegrationFactory", ^{
    it(@"factory creates integration with empty settings", ^{
        SEGFirebaseIntegration *integration = [[SEGFirebaseIntegrationFactory instance] createWithSettings:@{} forAnalytics:nil];
        
        expect(integration.settings).to.equal(@{});
    });
});

describe(@"SEGFirebaseIntegrationFactory", ^{
    it(@"factory creates integration with basic settings", ^{
        SEGFirebaseIntegration *integration = [[SEGFirebaseIntegrationFactory instance] createWithSettings:@{} forAnalytics:nil];
        
        expect(integration.settings).to.equal(@{});
    });
});

describe(@"SEGFirebaseIntegration", ^{
    __block Class mockFirebase;
    __block SEGFirebaseIntegration *integration;
    
    beforeEach(^{
        mockFirebase = mockClass([FIRApp class]);
        integration = [[SEGFirebaseIntegration alloc] initWithSettings:@{} andFirebase:mockFirebase];
    });
    
//    it(@"identify with Traits", ^{
//        SEGIdentifyPayload *payload = [[SEGIdentifyPayload alloc] initWithUserId:@"1111"
//                                                                     anonymousId:nil
//                                                                          traits:@{@"name":@"Kylo Ren",
//                                                                                   @"gender": @"male",
//                                                                                   @"emotion": @"angsty"}
//                                                                         context:@{} integrations:@{}];
//        
//        [integration identify:payload];
//        
//        [verify(mockFirebase) setLabel: @"name" value: @"Kylo Ren"];
//        [verify(mockFirebase) setLabel: @"gender" value: @"male"];
//        [verify(mockFirebase) setLabel: @"emotion" value: @"angsty"];
//    });
});

describe(@"these will pass", ^{ 
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"will wait and succeed", ^{
        waitUntil(^(DoneCallback done) {
            done();
        });
    });
});

SpecEnd

