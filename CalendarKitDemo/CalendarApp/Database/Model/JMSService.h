//
//  JMSService.h
//  CalendarApp
//
//  Created by Андрей Воевода on 21.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

#ifndef JMSService_h
#define JMSService_h
@interface JMSService : NSBeforeManagedObject <EKMappingProtocol>
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@end
#endif /* JMSService_h */
