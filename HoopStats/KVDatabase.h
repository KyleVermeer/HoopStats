//
//  KVDatabase.h
//  HoopStats
//
//  Created by Kyle Vermeer on 4/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//
//  This class was created to be subclassesed in future
//  applications.  Those subclasses should call [super
//  initWithDatabaseFileName:(NString*)] in their init methods.
//  They also have the options to override the
//  initilaizeDatabaseInManagedObjectContext method in
//  order to put seed data in the database upon creation.
//

#import <Foundation/Foundation.h>

@interface KVDatabase : NSObject

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@property (strong,nonatomic) NSString* databaseFileName;

/* Use the method in order to run any methods that require the document to be created.
 * This method will all the block when the document in created. */
-(void)performWithDocument:(OnDocumentReady)onDocumentReady;

// Designated Initializer
-(id)initWithDatabaseFileName:(NSString*)databaseFileName;

// Override this method in order to initialize the database the first time it is created
-(void)initializeDatabaseInManagedObjectContext:(NSManagedObjectContext*)moc;


@end
