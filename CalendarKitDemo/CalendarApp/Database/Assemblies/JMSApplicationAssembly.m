//
//  JMSApplicationAssembly.m
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import "JMSApplicationAssembly.h"
//#import "JMSAppDelegate.h"
//#import "JMSApplication.h"
#import "CalendarApp-Swift.h"
//#import "AppearanceHooks.h"
//#import "JMSSalonAppDelegate.h"
//#import "JMSSalonApplication.h"
//#import "JMSNetworkAlertImpl.h"
//#import "JMSMastersAppDelegate.h"

@implementation JMSApplicationAssembly {
    Managers *_managers;
    AppearanceHooks *_appearanceHooks;
    //JMSNetworkAlertImpl *_networkAlertImpl;
}

+ (instancetype)shared {
    static JMSApplicationAssembly *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [JMSApplicationAssembly new];
    }
    return sharedInstance;
}

- (Managers *)managers {
    if (_managers == nil) {
        _managers = [[Managers alloc] init:[JMSDAOAssembly shared] applicationAssembly:self];
    }
    return _managers;
}

- (AppearanceHooks *)appearanceHooks {
   // if (_appearanceHooks == nil) {
   //     _appearanceHooks = [AppearanceHooks new];
   // }
   // return _appearanceHooks;
    return nil;
}


- (id<JMSNetworkAlert>)networkAlert {
    return nil;
}
@end
