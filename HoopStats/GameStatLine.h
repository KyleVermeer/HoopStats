//
//  GameStatLine.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/16/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Player;

@interface GameStatLine : NSManagedObject

@property (nonatomic, retain) NSNumber * assists;
@property (nonatomic, retain) NSNumber * defensiveRebounds;
@property (nonatomic, retain) NSNumber * fouls;
@property (nonatomic, retain) NSNumber * offensiveRebounds;
@property (nonatomic, retain) NSNumber * onePointAttempted;
@property (nonatomic, retain) NSNumber * onePointMade;
@property (nonatomic, retain) NSNumber * steals;
@property (nonatomic, retain) NSNumber * threePointsAttempted;
@property (nonatomic, retain) NSNumber * threePointsMade;
@property (nonatomic, retain) NSNumber * turnovers;
@property (nonatomic, retain) NSNumber * twoPointsAttempted;
@property (nonatomic, retain) NSNumber * twoPointsMade;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) Player *player;

@end
