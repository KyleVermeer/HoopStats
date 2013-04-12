//
//  Game+Create.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "Game+Create.h"
#import "GameStatLine+Create.h"
#import "Team+Create.h"

@implementation Game (Create)

+(Game*)gameWithTeam:(Team*)team againstOpponent:(Team*)opponent inManagedObjectContext:(NSManagedObjectContext*)context
{
    Game *game = nil;
    if (!game) {
        //Create Game
        game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:context];
        game.teams = [NSSet setWithObjects:team,opponent, nil];
        game.date = [NSDate date];
        [game createStatLinesInManagedObjectContext:context];
    }
    return game;
}

-(void)createStatLinesInManagedObjectContext:(NSManagedObjectContext*)context;
{
    for (Team *team in self.teams) {
        for (Player *player in team.players) {
            [GameStatLine gameStatLineWithPlayer:player inGame:self inManagedObjectContext:context];
        }
    }
}

-(NSString*)description
{
    NSArray *teamsArray = [self.teams allObjects];
    return [NSString stringWithFormat:@"%@ vs %@ - %@",teamsArray[0],teamsArray[1],[self formattedDate]];
}

-(NSString*)formattedDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    return [dateFormatter stringFromDate:self.date];
}

@end
