//
//  JMSClient.m
//  CalendarApp
//
//  Created by Андрей Воевода on 22.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

#import "JMSClient.h"

@implementation JMSClient

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"id", @"name", @"surname", @"phone"]];
    }];
}

@end

