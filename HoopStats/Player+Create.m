//
//  Player+Create.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "Player+Create.h"
#import "Team.h"

@implementation Player (Create)

+(Player*)playerWithFirstName:(NSString *)firstName lastName:(NSString *)lastName number:(NSNumber *)number inManagedObjectContext:(NSManagedObjectContext *)context
{
    Player *player= nil;
    if (!player) {
        //Create Player
        player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:context];
        player.firstName = firstName;
        player.lastName = lastName;
        player.jerseyNumber = number;
    }
    return player;
}

-(NSString*)fullName
{
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@ %@ - %d",self.firstName,self.lastName,self.jerseyNumber.intValue];
}

@end
