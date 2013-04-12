//
//  GameStatLine+Create.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "GameStatLine.h"
#import "Player.h"
#import "Game.h"

@interface GameStatLine (Create)

+(GameStatLine*)gameStatLineWithPlayer:(Player*)player inGame:(Game*)game inManagedObjectContext:(NSManagedObjectContext*)context;

@end
