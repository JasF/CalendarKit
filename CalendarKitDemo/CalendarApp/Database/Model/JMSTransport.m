//
//  JMSTransport.m
//  CalendarApp
//
//  Created by Андрей Воевода on 15.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//


#import "JMSTransport.h"

@implementation JMSTransport

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"uid", @"name"]];
    }];
}

@end
