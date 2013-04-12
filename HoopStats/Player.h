//
//  Player.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/16/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameStatLine, Team;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * jerseyNumber;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *gameStatLines;
@property (nonatomic, retain) Team *team;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addGameStatLinesObject:(GameStatLine *)value;
- (void)removeGameStatLinesObject:(GameStatLine *)value;
- (void)addGameStatLines:(NSSet *)values;
- (void)removeGameStatLines:(NSSet *)values;

@end
