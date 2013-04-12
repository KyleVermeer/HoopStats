//
//  HSDatabase.h
//  StanfordSportCoreData
//
//  Created by Kyle Vermeer on 2/25/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KVDatabase.h"

@interface HSDatabase : KVDatabase

// Returns a single instance of the Database
+(id) sharedInstance;

@end
