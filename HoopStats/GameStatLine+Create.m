//
//  GameStatLine+Create.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "GameStatLine+Create.h"

@implementation GameStatLine (Create)

+(GameStatLine*)gameStatLineWithPlayer:(Player*)player inGame:(Game*)game inManagedObjectContext:(NSManagedObjectContext*)context
{
    GameStatLine *statLine = nil;
    if (!statLine) {
        //Create GameStatLine
        statLine = [NSEntityDescription insertNewObjectForEntityForName:@"GameStatLine" inManagedObjectContext:context];
        statLine.player = player;
        statLine.game = game;
    }
    return statLine;
}

@end
