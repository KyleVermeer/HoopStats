
//
//  HSDatabase.m
//  StanfordSportCoreData
//
//  Created by Kyle Vermeer on 2/25/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSDatabase.h"

/* Only for making initial data */
#import "Team+Create.h"
#import "Player+Create.h"

@interface HSDatabase()

@property (nonatomic) UIManagedDocument* managedDocument;
@property (nonatomic) BOOL firstCreation;

@end

@implementation HSDatabase

static HSDatabase* sharedInstance;

#define DATABASE_FILE_NAME @"managedDocumentDB"

/* Initialize shared instance with initialize, called once per class */
+(void)initialize
{
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        HSDatabase *database = [[HSDatabase alloc] init];
        sharedInstance = database;
    }
}

+(id)sharedInstance
{
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSURL* managedDocumentURL = [self getManagedDocumentURL];
        self.managedDocument = [[UIManagedDocument alloc] initWithFileURL:managedDocumentURL];
        self.firstCreation = NO;
    }
    return self;
}

-(void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        if (success) {
            onDocumentReady(self.managedDocument);
            if (self.firstCreation) {
                [self populateInitialDataInManagedObjectContext:self.managedDocument.managedObjectContext];
                self.firstCreation = NO;
            }
        } else {
            NSLog(@"Trouble opening the document at %@", self.managedDocument.fileURL);
            exit(1);
        }
    };
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.managedDocument.fileURL path]]) {
        [self.managedDocument saveToURL:self.managedDocument.fileURL
                forSaveOperation:UIDocumentSaveForCreating
                      completionHandler:OnDocumentDidLoad];
        self.firstCreation = YES;
    } else if (self.managedDocument.documentState == UIDocumentStateClosed) {
        [self.managedDocument openWithCompletionHandler:OnDocumentDidLoad];
    } else if (self.managedDocument.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);
    }
}

-(NSURL*)getManagedDocumentURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Get URL for our cache directory
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* documentsURL = urls[0];
    return [documentsURL URLByAppendingPathComponent:DATABASE_FILE_NAME];
}

-(void)populateInitialDataInManagedObjectContext:(NSManagedObjectContext*)context
{
    Team *bellarmine = [Team teamWithName:@"Bells" location:@"Bellarmine" inManagedObjectContext:context];
    Player *grant = [Player playerWithFirstName:@"Grant" lastName:@"Vermeer" number:@(21) inManagedObjectContext:context];
    Player *jackson = [Player playerWithFirstName:@"Jackson" lastName:@"Gion" number:@(24) inManagedObjectContext:context];
    Player *blair = [Player playerWithFirstName:@"Blair" lastName:@"Mendy" number:@(12) inManagedObjectContext:context];
    Player *jack = [Player playerWithFirstName:@"Jack" lastName:@"O'Hara" number:@(34) inManagedObjectContext:context];
    Player *danny = [Player playerWithFirstName:@"Danny" lastName:@"Schotzman" number:@(22) inManagedObjectContext:context];
    [bellarmine addPlayers:[NSSet setWithObjects:grant,jackson,blair,jack,danny, nil]];
    
    Team *saint_francis = [Team teamWithName:@"Lancers" location:@"Saint Francis" inManagedObjectContext:context];
    Player *khalid = [Player playerWithFirstName:@"Khalid" lastName:@"Johnson" number:@(3) inManagedObjectContext:context];
    Player *khalil = [Player playerWithFirstName:@"Khalil" lastName:@"Johnson" number:@(23) inManagedObjectContext:context];
    Player *michael = [Player playerWithFirstName:@"Michael" lastName:@"Lauck" number:@(5) inManagedObjectContext:context];
    Player *matthew = [Player playerWithFirstName:@"Matthew" lastName:@"Stauber" number:@(12) inManagedObjectContext:context];
    Player *darius = [Player playerWithFirstName:@"Darius" lastName:@"Thomas" number:@(15) inManagedObjectContext:context];
    [saint_francis addPlayers:[NSSet setWithObjects:khalid,khalil,michael,matthew,darius, nil]];
}

@end
