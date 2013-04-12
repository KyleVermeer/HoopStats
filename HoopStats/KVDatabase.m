//
//  KVDatabase.m
//  HoopStats
//
//  Created by Kyle Vermeer on 4/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "KVDatabase.h"

@interface KVDatabase()

@property (nonatomic) UIManagedDocument* managedDocument;
@property (nonatomic) BOOL firstCreation;

@end

@implementation KVDatabase

-(id)initWithDatabaseFileName:(NSString*)databaseFileName
{
    self = [super init];
    if (self) {
        self.databaseFileName = databaseFileName;
        NSURL* managedDocumentURL = [self getManagedDocumentURL];
        self.managedDocument = [[UIManagedDocument alloc] initWithFileURL:managedDocumentURL];
        self.firstCreation = NO;
    }
    return self;
}

// Force developer to use desginated initilaizer
-(id)init
{
    return nil;
}

-(void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    // Define block to be executed on document creation
    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        if (success) {
            onDocumentReady(self.managedDocument);
            // Allow the developer to perform some initial data-population when database is created
            if (self.firstCreation) {
                [self initializeDatabaseInManagedObjectContext:self.managedDocument.managedObjectContext];
                self.firstCreation = NO;
            }
        } else {
            NSLog(@"Trouble opening the document at %@", self.managedDocument.fileURL);
            exit(1);
        }
    };
    
    // If database doesn't exist, create it!
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.managedDocument.fileURL path]]) {
        [self.managedDocument saveToURL:self.managedDocument.fileURL
                       forSaveOperation:UIDocumentSaveForCreating
                      completionHandler:OnDocumentDidLoad];
        self.firstCreation = YES;
    }
    // We've created the database before, it's just closed
    else if (self.managedDocument.documentState == UIDocumentStateClosed) {
        [self.managedDocument openWithCompletionHandler:OnDocumentDidLoad];
    }
    // Database has been created and it's open
    else if (self.managedDocument.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);
    }
}

-(NSURL*)getManagedDocumentURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Put database in document directory
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* documentsURL = urls[0];
    return [documentsURL URLByAppendingPathComponent:self.databaseFileName];
}

-(void)initializeDatabaseInManagedObjectContext:(NSManagedObjectContext *)moc
{
    // Do nothing, should be overridden
    return;
}




@end
