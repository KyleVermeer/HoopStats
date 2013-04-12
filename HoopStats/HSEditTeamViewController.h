//
//  HSEditTeamViewController.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/14/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface HSEditTeamViewController : UIViewController

@property (weak, nonatomic) Team *team;
@property (nonatomic, readonly) NSString *teamName;
@property (nonatomic, readonly) NSString *teamLocation;

@end
