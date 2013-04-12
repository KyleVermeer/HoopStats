//
//  Team+Create.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "Team+Create.h"
#import "Player+Create.h"

@implementation Team (Create)

+(Team*)teamWithName:(NSString*)name location:(NSString*)location inManagedObjectContext:(NSManagedObjectContext*)context
{
    Team *team = nil;
    if (!team) {
        //Create Team
        team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
        team.teamName = name;
        team.location = location;
    }
    return team;
}

+(NSArray*)allTeamsInManagedObjectContext:(NSManagedObjectContext*)context
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"teamName" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    request.predicate = nil; // All teams
    return [context executeFetchRequest:request error:nil];
}

-(NSString*)description
{
    if ([self.location length] == 0) {
        return [NSString stringWithFormat:@"%@",self.teamName];
    } else {
        return [NSString stringWithFormat:@"%@ %@",self.location,self.teamName];
    }
}

-(NSArray*)playersSortedByJerseyNumber
{
    return [[self.players allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Player *firstPlayer = (Player*)obj1;
        Player *secondPlayer = (Player*)obj2;
        if (firstPlayer.jerseyNumber.intValue > secondPlayer.jerseyNumber.intValue) {
            return NSOrderedDescending;
        } else if (firstPlayer.jerseyNumber.intValue < secondPlayer.jerseyNumber.intValue) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];

}

@end
