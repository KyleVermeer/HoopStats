//
//  Team+Create.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "Team.h"

@interface Team (Create)

+(Team*)teamWithName:(NSString*)name location:(NSString*)location inManagedObjectContext:(NSManagedObjectContext*)context;
+(NSArray*)allTeamsInManagedObjectContext:(NSManagedObjectContext*)context;
-(NSArray*)playersSortedByJerseyNumber;

@end
