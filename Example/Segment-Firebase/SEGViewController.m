//
//  SEGViewController.m
//  Segment-Firebase
//
//  Created by wcjohnson11 on 07/25/2016.
//  Copyright (c) 2016 wcjohnson11. All rights reserved.
//

#import "SEGViewController.h"
#import <Analytics/SEGAnalytics.h>

@interface SEGViewController ()

@end

@implementation SEGViewController
- (IBAction)buttonTouch:(id)sender {
    [[SEGAnalytics sharedAnalytics] track:@"order Completed" properties:@{
                                                                         @"currency": @"USD",
                                                                         @"total": @"10.20"}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    	// Do any additional setup after loading the view, typically from a nib.
    [[SEGAnalytics sharedAnalytics] identify:@"123abc" traits:@{@"name":@"fred", @"gender":@"male"}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
