//
//  JMSTransport.h
//  CalendarApp
//
//  Created by Андрей Воевода on 15.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

#ifndef JMSTransport_h
#define JMSTransport_h
@interface JMSTransport : NSBeforeManagedObject <EKMappingProtocol>
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@end

#endif /* JMSTransport_h */
