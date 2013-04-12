//
//  HSGameListViewController.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/16/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface HSGameListViewController : UITableViewController

@property (strong, nonatomic) Team *team;

@end
