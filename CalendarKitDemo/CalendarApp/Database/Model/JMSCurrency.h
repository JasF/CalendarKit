//
//  JMSCurrency.h
//  CalendarApp
//
//  Created by Андрей Воевода on 29.10.24.
//  Copyright © 2024 Richard Topchii. All rights reserved.
//

#ifndef JMSCurrency_h
#define JMSCurrency_h
@interface JMSCurrency : NSBeforeManagedObject <EKMappingProtocol>
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *symbol;
@end

#endif /* JMSCurrency_h */
