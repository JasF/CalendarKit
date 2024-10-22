//
//  JMSClient.h
//  CalendarApp
//
//  Created by Андрей Воевода on 22.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

#ifndef JMSClient_h
#define JMSClient_h
@interface JMSClient : NSBeforeManagedObject <EKMappingProtocol>
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *phone;

@end


#endif /* JMSClient_h */
