
//
//  HSDatabase.m
//  StanfordSportCoreData
//
//  Created by Kyle Vermeer on 2/25/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSDatabase.h"

// Only for making initial data
#import "Team+Create.h"
#import "Player+Create.h"

@implementation HSDatabase

#define DATABASE_FILE_NAME @"hoopstats.db"

static KVDatabase* sharedInstance;

+(id)sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

-(id)init
{
    self = [super initWithDatabaseFileName:DATABASE_FILE_NAME];
    if (self) {
        // Nothing else needed
    }
    return self;
}

-(void)initializeDatabaseInManagedObjectContext:(NSManagedObjectContext *)moc
{
    Team *bellarmine = [Team teamWithName:@"Bells" location:@"Bellarmine" inManagedObjectContext:moc];
    Player *grant = [Player playerWithFirstName:@"Grant" lastName:@"Vermeer" number:@(21) inManagedObjectContext:moc];
    Player *jackson = [Player playerWithFirstName:@"Jackson" lastName:@"Gion" number:@(24) inManagedObjectContext:moc];
    Player *blair = [Player playerWithFirstName:@"Blair" lastName:@"Mendy" number:@(12) inManagedObjectContext:moc];
    Player *jack = [Player playerWithFirstName:@"Jack" lastName:@"O'Hara" number:@(34) inManagedObjectContext:moc];
    Player *danny = [Player playerWithFirstName:@"Danny" lastName:@"Schotzman" number:@(22) inManagedObjectContext:moc];
    [bellarmine addPlayers:[NSSet setWithObjects:grant,jackson,blair,jack,danny, nil]];
    
    Team *saint_francis = [Team teamWithName:@"Lancers" location:@"Saint Francis" inManagedObjectContext:moc];
    Player *khalid = [Player playerWithFirstName:@"Khalid" lastName:@"Johnson" number:@(3) inManagedObjectContext:moc];
    Player *khalil = [Player playerWithFirstName:@"Khalil" lastName:@"Johnson" number:@(23) inManagedObjectContext:moc];
    Player *michael = [Player playerWithFirstName:@"Michael" lastName:@"Lauck" number:@(5) inManagedObjectContext:moc];
    Player *matthew = [Player playerWithFirstName:@"Matthew" lastName:@"Stauber" number:@(12) inManagedObjectContext:moc];
    Player *darius = [Player playerWithFirstName:@"Darius" lastName:@"Thomas" number:@(15) inManagedObjectContext:moc];
    [saint_francis addPlayers:[NSSet setWithObjects:khalid,khalil,michael,matthew,darius, nil]];
}

@end
