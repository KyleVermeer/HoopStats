//
//  Game.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/16/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameStatLine, Team;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *gameStatLines;
@property (nonatomic, retain) NSSet *teams;
@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addGameStatLinesObject:(GameStatLine *)value;
- (void)removeGameStatLinesObject:(GameStatLine *)value;
- (void)addGameStatLines:(NSSet *)values;
- (void)removeGameStatLines:(NSSet *)values;

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

@end
