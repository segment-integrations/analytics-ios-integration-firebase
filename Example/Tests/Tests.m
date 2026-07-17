//
//  Segment-FirebaseTests.m
//  Segment-FirebaseTests
//
//  Created by wcjohnson11 on 07/25/2016.
//  Copyright (c) 2016 wcjohnson11. All rights reserved.
//

// https://github.com/Specta/Specta

SpecBegin(InitialSpecs);

describe(@"Firebase Integration", ^{
    __block id mockFirebase;
    __block SEGFirebaseIntegration *integration;

    beforeEach(^{
        mockFirebase = mockClass([FIRAnalytics class]);
        integration = [[SEGFirebaseIntegration alloc] initWithSettings:@{} andFirebase:mockFirebase];
    });

    it(@"identify with no traits", ^{
        SEGIdentifyPayload *payload = [[SEGIdentifyPayload alloc] initWithUserId:@"1111" anonymousId:nil traits:@{} context:@{} integrations:@{}];

        [integration identify:payload];
        [verify(mockFirebase) setUserID:@"1111"];

    });

    it(@"identify with traits", ^{
        SEGIdentifyPayload *payload = [[SEGIdentifyPayload alloc] initWithUserId:@"7891" anonymousId:nil traits:@{
            @"name" : @"Jerry Seinfield",
            @"gender" : @"male",
            @"emotion" : @"confused",
            @"age" : @47
        } context:@{}
            integrations:@{}];
        [integration identify:payload];
        [verify(mockFirebase) setUserID:@"7891"];
        [verify(mockFirebase) setUserPropertyString:@"Jerry Seinfield" forName:@"name"];
        [verify(mockFirebase) setUserPropertyString:@"male" forName:@"gender"];
        [verify(mockFirebase) setUserPropertyString:@"confused" forName:@"emotion"];
        [verify(mockFirebase) setUserPropertyString:@"47" forName:@"age"];


    });

    it(@"track with no props", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Email Sent" properties:@{} context:@{} integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"Email_Sent" parameters:@{}];
    });

    it(@"track with props", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Starship Ordered"
            properties:@{
                @"Starship Type" : @"Death Star"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"Starship_Ordered" parameters:@{
            @"Starship_Type" : @"Death Star"
        }];
    });

    it(@"track with event name and prop name > 40 chars", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"ufddxsblvtujywadkmohvddqnpbginxozqjffhjyy"
            properties:@{
                @"ufddxsblvtujywadkmohvddqnpbginxozqjffhjyy" : @"Death Star"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"ufddxsblvtujywadkmohvddqnpbginxozqjffhjy" parameters:@{
            @"ufddxsblvtujywadkmohvddqnpbginxozqjffhjy" : @"Death Star"
        }];
    });

    it(@"track with event name and parmas separated by periods", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Starship.Ordered"
                                                               properties:@{
                                                                            @"Starship.Type" : @"Death Star"
                                                                            }
                                                                  context:@{}
                                                             integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"Starship_Ordered" parameters:@{
                                                                                @"Starship_Type" : @"Death Star"
                                                                                }];
    });

    it(@"track with leading and trailing spacing for event name", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"   Starship Ordered  "
                                                               properties:@{
                                                                            @"Starship.Type" : @"Death Star"
                                                                            }
                                                                  context:@{}
                                                             integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"Starship_Ordered" parameters:@{
                                                                                @"Starship_Type" : @"Death Star"
                                                                                }];
    });
         
    it(@"track with leading and trailing spacing for event name with dashes", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"   Starship-Ordered  "
                                                               properties:@{
                                                                            @"Starship.Type" : @"Death Star"
                                                                            }
                                                                  context:@{}
                                                             integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"Starship_Ordered" parameters:@{
                                                                                @"Starship_Type" : @"Death Star"
                                                                                }];
    });

    it(@"track Order Completed", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Order Completed" properties:@{
            @"checkout_id" : @"9bcf000000000000",
            @"order_id" : @"50314b8e",
            @"affiliation" : @"App Store",
            @"total" : @30.45,
            @"shipping" : @5.05,
            @"tax" : @1.20,
            @"currency" : @"USD",
            @"category" : @"Games",
            @"revenue" : @8,
            @"products" : @[
                @{
                    @"product_id" : @"2013294",
                    @"category" : @"Games",
                    @"name" : @"Monopoly: 3rd Edition",
                    @"brand" : @"Hasbros",
                    @"price" : @"21.99",
                    @"quantity" : @"1"
                }
            ]
        }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        // TODO: look into how to handle mapping Firebase reserved params to each products
        [verify(mockFirebase) logEventWithName:@"purchase" parameters:@{
            @"checkout_id" : @"9bcf000000000000",
            @"transaction_id" : @"50314b8e",
            @"affiliation" : @"App Store",
            @"value" : @30.45,
            @"shipping" : @5.05,
            @"tax" : @1.20,
            @"currency" : @"USD",
            @"item_category" : @"Games",
            @"items" : @[
                @{
                    @"item_id" : @"2013294",
                    @"item_category" : @"Games",
                    @"item_name" : @"Monopoly: 3rd Edition",
                    @"item_brand" : @"Hasbros",
                    @"price" : @"21.99",
                    @"quantity" : @"1"
                }
            ]
        }];
    });

    it(@"track Product Clicked", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Product Clicked"
            properties:@{
                @"product_id" : @"507f1f77bcf86cd799439011",
                @"sku" : @"G-32",
                @"category" : @"Games",
                @"name" : @"Monopoly: 3rd Edition",
                @"brand" : @"Hasbro",
                @"variant" : @"200 pieces",
                @"price" : @18.99,
                @"quantity" : @1,
                @"coupon" : @"MAYDEALS",
                @"position" : @3,
                @"url" : @"https://www.company.com/product/path",
                @"image_url" : @"https://www.company.com/product/path.jpg"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"select_content" parameters:@{
            @"item_id" : @"507f1f77bcf86cd799439011",
            @"sku" : @"G-32",
            @"item_category" : @"Games",
            @"item_name" : @"Monopoly: 3rd Edition",
            @"item_brand" : @"Hasbro",
            @"variant" : @"200 pieces",
            @"price" : @18.99,
            @"quantity" : @1,
            @"coupon" : @"MAYDEALS",
            @"position" : @3,
            @"url" : @"https://www.company.com/product/path",
            @"image_url" : @"https://www.company.com/product/path.jpg"
        }];
    });

    it(@"track Product Viewed", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Product Viewed"
            properties:@{
                @"product_id" : @"507f1f77bcf86cd799439011",
                @"sku" : @"G-32",
                @"category" : @"Games",
                @"name" : @"Monopoly 3rd Edition",
                @"brand" : @"Hasbro",
                @"variant" : @"200 pieces",
                @"price" : @18.99,
                @"quantity" : @1,
                @"coupon" : @"MAYDEALS",
                @"currency" : @"usd",
                @"position" : @3,
                @"url" : @"https://www.company.com/product/path",
                @"image_url" : @"https://www.company.com/product/path.jpg"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"view_item" parameters:@{
            @"item_id" : @"507f1f77bcf86cd799439011",
            @"sku" : @"G-32",
            @"item_category" : @"Games",
            @"item_name" : @"Monopoly 3rd Edition",
            @"item_brand" : @"Hasbro",
            @"variant" : @"200 pieces",
            @"price" : @18.99,
            @"quantity" : @1,
            @"coupon" : @"MAYDEALS",
            @"currency" : @"usd",
            @"position" : @3,
            @"url" : @"https://www.company.com/product/path",
            @"image_url" : @"https://www.company.com/product/path.jpg"
        }];
    });

    it(@"track Product Added", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Product Added"
            properties:@{
                @"cart_id" : @"skdjsidjsdkdj29j",
                @"product_id" : @"507f1f77bcf86cd799439011",
                @"sku" : @"G-32",
                @"category" : @"Games",
                @"name" : @"Monopoly: 3rd Edition",
                @"brand" : @"Hasbro",
                @"variant" : @"200 pieces",
                @"price" : @18.99,
                @"quantity" : @1,
                @"coupon" : @"MAYDEALS",
                @"position" : @3,
                @"url" : @"https://www.company.com/product/path",
                @"image_url" : @"https://www.company.com/product/path.jpg"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"add_to_cart" parameters:@{
            @"cart_id" : @"skdjsidjsdkdj29j",
            @"item_id" : @"507f1f77bcf86cd799439011",
            @"sku" : @"G-32",
            @"item_category" : @"Games",
            @"item_name" : @"Monopoly: 3rd Edition",
            @"item_brand" : @"Hasbro",
            @"variant" : @"200 pieces",
            @"price" : @18.99,
            @"quantity" : @1,
            @"coupon" : @"MAYDEALS",
            @"position" : @3,
            @"url" : @"https://www.company.com/product/path",
            @"image_url" : @"https://www.company.com/product/path.jpg"
        }];
    });

    it(@"track Product Removed", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Product Removed"
            properties:@{
                @"cart_id" : @"ksjdj92dj29dj92d2j",
                @"product_id" : @"507f1f77bcf86cd799439011",
                @"sku" : @"G-32",
                @"category" : @"Games",
                @"name" : @"Monopoly: 3rd Edition",
                @"brand" : @"Hasbro",
                @"variant" : @"200 pieces",
                @"price" : @18.99,
                @"quantity" : @1,
                @"coupon" : @"MAYDEALS",
                @"position" : @3,
                @"url" : @"https://www.company.com/product/path",
                @"image_url" : @"https://www.company.com/product/path.jpg"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"remove_from_cart" parameters:@{
            @"cart_id" : @"ksjdj92dj29dj92d2j",
            @"item_id" : @"507f1f77bcf86cd799439011",
            @"sku" : @"G-32",
            @"item_category" : @"Games",
            @"item_name" : @"Monopoly: 3rd Edition",
            @"item_brand" : @"Hasbro",
            @"variant" : @"200 pieces",
            @"price" : @18.99,
            @"quantity" : @1,
            @"coupon" : @"MAYDEALS",
            @"position" : @3,
            @"url" : @"https://www.company.com/product/path",
            @"image_url" : @"https://www.company.com/product/path.jpg"
        }];
    });

    it(@"track Checkout Started", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Checkout Started"
            properties:@{
                @"checkout_id" : @"9bcf000000000000",
                @"order_id" : @"50314b8e",
                @"affiliation" : @"App Store",
                @"total" : @30.45,
                @"shipping" : @5.05,
                @"tax" : @1.20,
                @"currency" : @"USD",
                @"category" : @"Games",
                @"revenue" : @8,
                @"products" : @[
                    @{
                        @"product_id" : @"2013294",
                        @"category" : @"Games",
                        @"name" : @"Monopoly: 3rd Edition",
                        @"brand" : @"Hasbros",
                        @"price" : @"21.99",
                        @"quantity" : @"1"
                    }
                ]
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"begin_checkout" parameters:@{
            @"checkout_id" : @"9bcf000000000000",
            @"transaction_id" : @"50314b8e",
            @"affiliation" : @"App Store",
            @"value" : @30.45,
            @"shipping" : @5.05,
            @"tax" : @1.20,
            @"currency" : @"USD",
            @"item_category" : @"Games",
            @"items" : @[
                @{
                    @"item_id" : @"2013294",
                    @"item_category" : @"Games",
                    @"item_name" : @"Monopoly: 3rd Edition",
                    @"item_brand" : @"Hasbros",
                    @"price" : @"21.99",
                    @"quantity" : @"1"
                }
            ]
        }];
    });

    it(@"track Promotion Viewed", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Promotion Viewed"
            properties:@{
                @"product_id" : @"507f1f77bcf86cd799439011",
                @"category" : @"Games",
                @"name" : @"Monopoly 3rd Edition",
                @"price" : @18.99,
                @"quantity" : @1,
                @"currency" : @"usd",
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"view_promotion" parameters:@{
            @"item_id" : @"507f1f77bcf86cd799439011",
            @"item_category" : @"Games",
            @"item_name" : @"Monopoly 3rd Edition",
            @"price" : @18.99,
            @"quantity" : @1,
            @"currency" : @"usd",
        }];
    });

    it(@"track Payment Info Entered", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Payment Info Entered"
            properties:@{
                @"checkout_id" : @"39f39fj39f3jf93fj9fj39fj3f",
                @"order_id" : @"dkfsjidfjsdifsdfksdjfkdsfjsdfkdsf",
                @"step" : @"Payment",
                @"shipping_method" : @"ground",
                @"payment_method" : @"credit card"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"add_payment_info" parameters:@{
            @"checkout_id" : @"39f39fj39f3jf93fj9fj39fj3f",
            @"transaction_id" : @"dkfsjidfjsdifsdfksdjfkdsfjsdfkdsf",
            @"step" : @"Payment",
            @"shipping_method" : @"ground",
            @"payment_method" : @"credit card"
        }];
    });

    it(@"track Order Refunded", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Order Refunded"
            properties:@{
                @"order_id" : @"50314b8e9bcf000000000000"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"refund" parameters:@{
            @"transaction_id" : @"50314b8e9bcf000000000000"
        }];
    });


    it(@"track Product List Viewed", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Product List Viewed"
            properties:@{
                @"list_id" : @"hot_deals_1",
                @"category" : @"Deals",
                @"products" : @[
                    @{
                        @"product_id" : @"2013294",
                        @"category" : @"Games",
                        @"name" : @"Monopoly: 3rd Edition",
                        @"brand" : @"Hasbros",
                        @"price" : @"21.99",
                        @"quantity" : @"1"
                    }
                ]
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"view_item_list" parameters:@{
            @"list_id" : @"hot_deals_1",
            @"item_category" : @"Deals",
            @"items" : @[
                @{
                    @"item_id" : @"2013294",
                    @"item_category" : @"Games",
                    @"item_name" : @"Monopoly: 3rd Edition",
                    @"item_brand" : @"Hasbros",
                    @"price" : @"21.99",
                    @"quantity" : @"1"
                }
            ]
        }];
    });


    it(@"track Product Added to Wishlist", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Product Added to Wishlist"
            properties:@{
                @"wishlist_id" : @"skdjsidjsdkdj29j",
                @"wishlist_name" : @"Loved Games",
                @"product_id" : @"507f1f77bcf86cd799439011",
                @"sku" : @"G-32",
                @"category" : @"Games",
                @"name" : @"Monopoly: 3rd Edition",
                @"brand" : @"Hasbro",
                @"variant" : @"200 pieces",
                @"price" : @18.99,
                @"quantity" : @1,
                @"coupon" : @"MAYDEALS",
                @"position" : @3,
                @"url" : @"https://www.company.com/product/path",
                @"image_url" : @"https://www.company.com/product/path.jpg"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"add_to_wishlist" parameters:@{
            @"wishlist_id" : @"skdjsidjsdkdj29j",
            @"wishlist_name" : @"Loved Games",
            @"item_id" : @"507f1f77bcf86cd799439011",
            @"sku" : @"G-32",
            @"item_category" : @"Games",
            @"item_name" : @"Monopoly: 3rd Edition",
            @"item_brand" : @"Hasbro",
            @"variant" : @"200 pieces",
            @"price" : @18.99,
            @"quantity" : @1,
            @"coupon" : @"MAYDEALS",
            @"position" : @3,
            @"url" : @"https://www.company.com/product/path",
            @"image_url" : @"https://www.company.com/product/path.jpg"
        }];
    });


    it(@"track Product Shared", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Product Shared"
            properties:@{
                @"share_via" : @"email",
                @"share_message" : @"Hey, check out this item",
                @"recipient" : @"friend@gmail.com",
                @"product_id" : @"507f1f77bcf86cd799439011",
                @"sku" : @"G-32",
                @"category" : @"Games",
                @"name" : @"Monopoly: 3rd Edition",
                @"brand" : @"Hasbro",
                @"variant" : @"200 pieces",
                @"price" : @18.99,
                @"url" : @"https://www.company.com/product/path",
                @"image_url" : @"https://www.company.com/product/path.jpg"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"share" parameters:@{
            @"share_via" : @"email",
            @"share_message" : @"Hey, check out this item",
            @"recipient" : @"friend@gmail.com",
            @"item_id" : @"507f1f77bcf86cd799439011",
            @"sku" : @"G-32",
            @"item_category" : @"Games",
            @"item_name" : @"Monopoly: 3rd Edition",
            @"item_brand" : @"Hasbro",
            @"variant" : @"200 pieces",
            @"price" : @18.99,
            @"url" : @"https://www.company.com/product/path",
            @"image_url" : @"https://www.company.com/product/path.jpg"
        }];
    });

    it(@"track Cart Shared", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Cart Shared"
            properties:@{
                @"share_via" : @"email",
                @"share_message" : @"Hey, check out this item",
                @"recipient" : @"friend@gmail.com",
                @"product_id" : @"507f1f77bcf86cd799439011",
                @"sku" : @"G-32",
                @"category" : @"Games",
                @"name" : @"Monopoly: 3rd Edition",
                @"brand" : @"Hasbro",
                @"variant" : @"200 pieces",
                @"price" : @18.99,
                @"url" : @"https://www.company.com/product/path",
                @"image_url" : @"https://www.company.com/product/path.jpg"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"share" parameters:@{
            @"share_via" : @"email",
            @"share_message" : @"Hey, check out this item",
            @"recipient" : @"friend@gmail.com",
            @"item_id" : @"507f1f77bcf86cd799439011",
            @"sku" : @"G-32",
            @"item_category" : @"Games",
            @"item_name" : @"Monopoly: 3rd Edition",
            @"item_brand" : @"Hasbro",
            @"variant" : @"200 pieces",
            @"price" : @18.99,
            @"url" : @"https://www.company.com/product/path",
            @"image_url" : @"https://www.company.com/product/path.jpg"
        }];
    });

    it(@"track Products Searched", ^{
        SEGTrackPayload *payload = [[SEGTrackPayload alloc] initWithEvent:@"Products Searched"
            properties:@{
                @"query" : @"blue hotpants"
            }
            context:@{}
            integrations:@{}];

        [integration track:payload];
        [verify(mockFirebase) logEventWithName:@"search" parameters:@{
            @"search_term" : @"blue hotpants"
        }];
    });

    it(@"track screen with name", ^{
        SEGScreenPayload *payload = [[SEGScreenPayload alloc] initWithName:@"Home screen"
                                                                  category:@""
                                                                properties:@{}
                                                                   context:@{}
                                                              integrations:@{}];
        [integration screen:payload];
        // screen is set async, so need to pump the runloop.
        [NSRunLoop.mainRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
        [verify(mockFirebase) logEventWithName:@"screen_view" parameters:@{
            kFIRParameterScreenName : @"Home screen"
        }];
    });

});

SpecEnd
