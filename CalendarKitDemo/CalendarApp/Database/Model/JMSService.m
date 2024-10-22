//
//  JMSService.m
//  CalendarApp
//
//  Created by Андрей Воевода on 21.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//


#import "JMSService.h"

@implementation JMSService

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"uid", @"name"]];
    }];
}

@end

