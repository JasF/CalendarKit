//
//  JMSCurrency.m
//  CalendarApp
//
//  Created by Андрей Воевода on 29.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

#import "JMSCurrency.h"

@implementation JMSCurrency

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"uid", @"name", @"symbol"]];
    }];
}

@end
