//
//  JMSApplicationAssembly.h
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import "JMSDAOAssembly.h"

@protocol JMSNetworkAlert;

@class AppearanceHooks;
@class Managers;

@interface JMSApplicationAssembly : NSObject
@property (nonatomic, strong) JMSDAOAssembly *daoAssembly;
+ (instancetype)shared;
- (AppearanceHooks *)appearanceHooks;
- (id<JMSNetworkAlert>)networkAlert;
- (Managers *)managers;
@end
