//
//  Player+Create.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "Player.h"

@interface Player (Create)

@property (nonatomic, readonly, getter = fullName) NSString* fullName;

+(Player*)playerWithFirstName:(NSString*)firstName lastName:(NSString*)lastName number:(NSNumber*)number inManagedObjectContext:(NSManagedObjectContext*)context;

@end
