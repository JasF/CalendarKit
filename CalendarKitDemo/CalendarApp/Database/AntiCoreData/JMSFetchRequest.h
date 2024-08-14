//
//  JMSFetchRequest.h
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMSEntityDescription;


@interface JMSFetchRequest : NSObject
@property (nonatomic, strong) id entity;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) NSArray<NSSortDescriptor *> *sortDescriptors;
@property (nonatomic) NSInteger fetchLimit;
@property (nonatomic) NSInteger fetchBatchSize;
@property (nonatomic) BOOL includesPendingChanges;

+ (instancetype)fetchRequestWithEntityName:(NSString*)entityName;
- (instancetype)init;
- (instancetype)initWithEntityName:(NSString*)entityName;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
