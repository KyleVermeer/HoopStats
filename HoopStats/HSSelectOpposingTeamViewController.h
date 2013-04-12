//
//  HSSelectOpposingTeamViewController.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/14/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team+Create.h"

@interface HSSelectOpposingTeamViewController : UIViewController

@property (strong, nonatomic ,readonly) Team *selectedTeam;
@property (strong, nonatomic) Team *originalTeam;

@end
