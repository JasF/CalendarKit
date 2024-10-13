//
//  JMSColor.h
//  CalendarApp
//
//  Created by Андрей Воевода on 13.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

#ifndef JMSColor_h
#define JMSColor_h

@interface JMSColor : NSBeforeManagedObject <EKMappingProtocol>
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *color;
@end

#endif /* JMSColor_h */
