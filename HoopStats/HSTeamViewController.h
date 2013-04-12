//
//  HSTeamViewController.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface HSTeamViewController : UIViewController

@property (strong, nonatomic) Team *team;

@property (strong, nonatomic) NSManagedObjectContext *moc;

@end
