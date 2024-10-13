//
//  JMSColor.m
//  CalendarApp
//
//  Created by Андрей Воевода on 13.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

#import "JMSColor.h"

@implementation JMSColor

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"uid", @"name", @"color"]];
    }];
}

@end
